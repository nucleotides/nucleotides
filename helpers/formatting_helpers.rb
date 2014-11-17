module FormattingHelpers

  def maintainer(string)
    string.split('/')[0]
  end

  def image(string)
    string.split('/')[1]
  end

  def bundle(string)
    string.split('/')[2]
  end

  def maintainer_image(string)
    maintainer(string) + "/" + image(string)
  end

  def header(string)
    string.gsub("\n", '<br/>')
  end


  def format_decimal(v)
    if v.nil?
      "No Value"
    else
      sprintf "%.2f", v
    end
  end

end
