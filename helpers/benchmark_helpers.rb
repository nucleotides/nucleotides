module BenchmarkHelpers

  def data_description(id)
    datum = data.genomes[id.to_sym]
    gc    = round_gc datum[:gc]
    size  = round_size datum[:size]

    "Microbe - approx. size: #{size}MBp, approx. GC: #{gc}%"
  end

end

def round_gc(v)
  (v / 10).round * 10
end

def round_size(v)
  (v / 1000000).round
end
