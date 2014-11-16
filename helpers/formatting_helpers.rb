module FormattingHelpers

  def format_decimal(v)
    if v.nil?
      "No Value"
    else
      sprintf "%.2f", v
    end
  end

end
