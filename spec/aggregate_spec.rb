require 'evaluation/aggregate'

RSpec.describe Evaluation::Aggregate do

  def benchmark(metrics = nil)
    b = {
      status: :complete,
      trial: {
      metrics: [
        {cpu_usage: 10, mem_usage: 10, time: 60},
        {cpu_usage: 20, mem_usage: 20, time: 120},
        {cpu_usage: 30, mem_usage: 30, time: 180}]},
      assessment: {}}
    b[:assessment][:metrics] = metrics.nil? ? [{key: "a", value: 1}, {key: "b", value: 1}] : metrics
    b
  end

  describe "#aggregate" do

    it "should list ':not_enough_replicates' when there are less the required benchmarks" do
      input  = [benchmark, benchmark, benchmark]
      output = described_class.aggregate(input)
      expect(output).to eq({status: :not_enough_replicates})
    end

    it "should list ':not_started' when any of the evaluations are not started" do
      input  = [{status: :not_started}] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({status: :not_started})
    end

    it "should list ':failed_trial' when any of the evaluation trials failed" do
      input  = [{status: :trial_failed}] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({status: :trial_failed})
    end

    it "should list ':not_assessed' when some of the evaluations are not assessed" do
      input  = [{status: :not_assessed}] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({status: :not_assessed})
    end

    it "should list ':assessment_failed' when any of the evaluation assessments failed" do
      input  = [{status: :assessment_failed}] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({status: :assessment_failed})
    end

    it "should aggregate the benchmarks when given the required amount" do
      input = [benchmark] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :complete,
        metrics: {
          "a"       => 1.0,
          "b"       => 1.0,
          "max_cpu" => 30.0,
          "max_mem" => 30.0
        }
      })
    end

    it "should ignore missing cgroup metrics" do
      input = [benchmark] * 5
      input[0][:trial][:metrics][2][:cpu_usage] = nil

      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :complete,
        metrics: {
          "a"       => 1.0,
          "b"       => 1.0,
          "max_cpu" => 20.0,
          "max_mem" => 30.0
        }
      })
    end

    it "should list ':missing_data' when there is missing metric data" do
      input = ([benchmark] * 4) << benchmark([{key: "a", value: 1}])
       output = described_class.aggregate(input)
       expect(output).to eq({status: :missing_data})
    end

    it "should correctly calculate the mean of the benchmark values" do
      input = [
        benchmark([{key: "a", value: 1}]),
        benchmark([{key: "a", value: 2}]),
        benchmark([{key: "a", value: 3}]),
        benchmark([{key: "a", value: 4}]),
        benchmark([{key: "a", value: 5}])
      ]
      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :complete,
        metrics: {
          "a"       => 3.0,
          "max_cpu" => 30.0,
          "max_mem" => 30.0
        }
      })
    end

  end

end
