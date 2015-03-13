module BenchmarkHelpers

  FORMATTERS = {
    local_mis:     -> (v) {round_nearest(v, 1)},
    mis:           -> (v) {round_nearest(v, 1)},
    fraction:      -> (v) {sprintf "%.2f", v},
    incorrect:     -> (v) {sprintf "%.2f", v},
    cpu:           -> (v) {sprintf "%.2f", v * NANOSECONDS_TO_HOURS},
    memory:        -> (v) {sprintf "%.2f", v / BYTES_TO_GIGABYTES},
    secs_per_kbp:  -> (v) {sprintf "%.2f", v.to_f * NANOSECONDS_TO_SECS * KILOBASE},
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
