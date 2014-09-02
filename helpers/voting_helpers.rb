module VotingHelpers

  def winning_image(dataset)
    data[dataset].first.first
  end

  def winning_proc(dataset)
    data[dataset].first.last
  end

end
