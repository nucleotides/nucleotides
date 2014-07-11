module PageHelpers

  def title
    titles = ['nucleotides', 'genome assembler benchmarking']
    if current_page.data['title']
      titles.unshift current_page.data['title']
    end
    titles.join(' &middot; ')
  end

  def data_description(id)
    datum = data.data[id.to_sym]
    gc   = round_gc datum[:gc]
    size = round_size datum[:size]
    "Microbe - approx. size: #{size}MBp, approx. GC: #{gc}%"
  end

end

def round_gc(v)
  (v / 10).round * 10
end

def round_size(v)
  (v / 1000000).round
end
