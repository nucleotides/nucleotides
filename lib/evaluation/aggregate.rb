module Evaluation
  module Aggregate
    class << self

      NUMBER_OF_REPLICATES = 5

      def mean(a)
        a.inject(&:+) / a.length.to_f
      end

      def cgroup_metric(hash, key)
        hash[:trial][:metrics].map{|i| i[key] }.compact.max
      end

      def any?(benchmarks, state)
        benchmarks.any?{|b| b[:status] == state}
      end


      def aggregate(benchmarks)
        if benchmarks.length < NUMBER_OF_REPLICATES
          {status: :not_enough_replicates}
        elsif any? benchmarks, :not_started
          {status: :not_started}
        elsif any? benchmarks, :trial_failed
          {status: :trial_failed}
        elsif any? benchmarks, :not_assessed
          {status: :not_assessed}
        elsif any? benchmarks, :assessment_failed
          {status: :assessment_failed}
        else
          data = benchmarks.map do |b|
            cgroup = [{key: "max_cpu", value: cgroup_metric(b, :cpu_usage)},
                      {key: "max_mem", value: cgroup_metric(b, :mem_usage)}]
            b[:assessment][:metrics] + cgroup
          end

          data_keys = data.inject(Set.new) do |set, datum|
            datum.each{|i| set << i[:key]}
            set
          end

          missing = data.any? do |datum|
            datum.map{|i| i[:key]} != data_keys.to_a
          end
          return {status: :missing_data} if missing

          metrics = Hash[data_keys.map do |key|
            values = data.map do |datum|
              d = datum.detect{|i| i[:key] == key}
              d[:value]
            end
            [key, mean(values)]
          end]
          {status: :complete, metrics: metrics}
        end
      end

      def remap(depth, data, &block)
        data.each do |i|
          i[:values] = (depth == 0) ? block.call(i[:values]) : remap(depth - 1, i[:values], &block)
        end
      end

    end
  end
end
