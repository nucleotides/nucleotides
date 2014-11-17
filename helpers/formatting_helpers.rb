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


  def format_decimal(v)
    if v.nil?
      "No Value"
    else
      sprintf "%.2f", v
    end
  end

end
