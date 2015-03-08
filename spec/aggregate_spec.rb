require 'evaluation/aggregate'

RSpec.describe Evaluation::Aggregate do

  def benchmark(opts = {})
    {cgroup: [
      {cpu_usage: 10, mem_usage: 10, time: 60},
      {cpu_usage: 20, mem_usage: 20, time: 120},
      {cpu_usage: 30, mem_usage: 30, time: 180}
    ],
     evaluation: [
       {key: "a", value: 1},
       {key: "b", value: 1}

    ]}.merge(opts)
  end

  describe "#aggregate" do

    it "should list ':not_enough_replicates' when there are less the required benchmarks" do
      input  = [benchmark, benchmark, benchmark]
      output = described_class.aggregate(input)
      expect(output).to eq({status: :not_enough_replicates})
    end

    it "should list ':no_data' when there in no metric data" do
      input  = [{}, {}, {}, {}, {}]
      output = described_class.aggregate(input)
      expect(output).to eq({status: :no_data})
    end

    it "should list ':missing_data' when there is missing metric data" do
      input = ([benchmark] * 4) << benchmark({evaluation: [{key: "a", value: 1}]})
      output = described_class.aggregate(input)
      expect(output).to eq({status: :missing_data})
    end

    it "should aggregate the benchmarks when given the required amount" do
      input = [benchmark] * 5
      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :ok,
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
      input[0][:cgroup][2][:cpu_usage] = nil

      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :ok,
        metrics: {
          "a"       => 1.0,
          "b"       => 1.0,
          "max_cpu" => 20.0,
          "max_mem" => 30.0
        }
      })
    end

    it "should correctly calculate the mean of the benchmark values" do
      input = [
        benchmark({evaluation: [{key: "a", value: 1}]}),
        benchmark({evaluation: [{key: "a", value: 2}]}),
        benchmark({evaluation: [{key: "a", value: 3}]}),
        benchmark({evaluation: [{key: "a", value: 4}]}),
        benchmark({evaluation: [{key: "a", value: 5}]})
      ]
      output = described_class.aggregate(input)
      expect(output).to eq({
        status: :ok,
        metrics: {
          "a"       => 3.0,
          "max_cpu" => 30.0,
          "max_mem" => 30.0
        }
      })
    end

  end

end
