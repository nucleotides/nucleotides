module Evaluation
  class << self

    NUMBER_OF_REPLICATES = 5

    def mean(a)
      a.inject(&:+) / a.length.to_f
    end

    def cgroup_metric(hash, key)
      hash[:cgroup].map{|i| i[key] }.compact.max
    end

    def aggregate(benchmarks)
      if benchmarks.length < NUMBER_OF_REPLICATES
        {status: :not_enough_replicates}
      elsif benchmarks.any?{|b| b[:cgroup].nil? or b[:evaluation].nil?}
        {status: :no_data}
      else
        data = benchmarks.map do |b|
          cgroup = [{key: "max_cpu", value: cgroup_metric(b, :cpu_usage)},
                    {key: "max_mem", value: cgroup_metric(b, :mem_usage)}]
          b[:evaluation] + cgroup
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
        {status: :ok, metrics: metrics}
      end
    end

    def remap(depth, data, &block)
      data.each do |i|
        i[:values] = (depth == 0) ? block.call(i[:values]) : remap(depth - 1, i[:values], &block)
      end
    end

  end
end
