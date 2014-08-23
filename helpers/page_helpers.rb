module PageHelpers

  def title
    titles = ['nucleotides', 'genome assembler benchmarking']
    page_title = current_page.data['title']
    titles.unshift page_title if page_title
    titles.join(' &middot; ')
  end

end
