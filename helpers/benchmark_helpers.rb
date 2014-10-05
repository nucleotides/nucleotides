module BenchmarkHelpers

  VALUES = {
    proc:      [:metadata, :prc],
    ng50:      [:summary_metrics, :ng50],
    lg50:      [:summary_metrics, :lg50],
    contigs:   [:summary_metrics, :n_contigs_gt_1000],
    fraction:  [:summary_metrics, :genome_fraction],
    incorrect: [:summary_metrics, :incorrect_per_100k],
    cpu:       [:summary_metrics, :total_cpu_hours],
    memory:    [:summary_metrics, :max_memory_gbytes],
  }

  FORMATTERS = {
    ng50:      -> (v) {round_nearest(v, 1000)},
    lg50:      -> (v) {round_nearest(v, 1)},
    contigs:   -> (v) {round_nearest(v, 1)},
    fraction:  -> (v) {sprintf "%.2f", v},
    incorrect: -> (v) {sprintf "%.2f", v},
    cpu:       -> (v) {sprintf "%.2f", v},
    memory:    -> (v) {sprintf "%.2f", v},
  }

  def table_value(name, v)
    value = VALUES[name].inject(v){|value, method| value.send method}
    raise ArgumentError "No value #{name}" if value.nil?

    if fmt = FORMATTERS[name]
      fmt.call(value)
    else
      value
    end
  end

  def data_id(id)
    id.to_s.rjust(4, "0")
  end

  def data_description(id)
    datum = data.genomes[data_id(id).to_sym]
    raise ArgumentError, "No genome metrics found for dataset #{id}" if datum.nil?

    gc    = round_nearest(datum[:gc], 10)
    size  = round_size datum[:size]

    "Microbe - approx. size: #{size}MBp, approx. GC: #{gc}%"
  end

  def datasets
    data.benchmarks.reject{|(k, _)| data.ignore.include? k}
  end

end

def round_nearest(v, n)
  (v / n).round * n
end

def round_size(v)
  (v / 1000000).round
end
