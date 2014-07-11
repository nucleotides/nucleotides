module PageHelpers

  def title
    titles = ['nucleotides', 'genome assembler benchmarking']
    if current_page.data['title']
      titles.unshift current_page.data['title']
    end
    titles.join(' &middot; ')
  end

end
