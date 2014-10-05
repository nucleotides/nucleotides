VALUES = [
  {avail: lambda{|i| ! i[:homepage].nil? },
   text:  ["Homepage", "No homepage available"],
   url:   lambda{|i| i[:homepage] }},

  {avail: lambda{|i| ! i[:image][:source].nil? },
   text:  ["Source Code Repository", "No source code repository available"],
   url:   lambda{|i| i[:image][:source] }},

  {avail: lambda{|i| ! i[:mailing_list].nil? },
   text:  ["Mailing List", "No mailing list available"],
   url:   lambda{|i| i[:mailing_list] }},
]

module PageHelpers
  def title
    titles = ['nucleotides', 'genome assembler benchmarking']
    page_title = current_page.data['title']
    titles.unshift page_title if page_title
    titles.join(' &middot; ')
  end

  def assembler_values(assembler)
    VALUES.map do |v|
      avail = v[:avail].call(assembler)
      if avail
        [avail, v[:url].call(assembler), v[:text].first]
      else
        [avail, nil, v[:text].last]
      end
    end
  end

  def dockerhub_url(assembler)
    "https://registry.hub.docker.com/u/" + assembler[:image][:dockerhub]
  end

  def pubmed_url(assembler)
    "https://www.ncbi.nlm.nih.gov/pubmed/" + assembler[:pmid].to_s
  end

  def assembler_id(docker_string)
    chars = %w|_ /|
    chars.inject(docker_string){|s, char| s.gsub(char, '-')}
  end

  def link_to_assembler(docker_string)
    "/assemblers#" + assembler_id(docker_string)
  end


end
