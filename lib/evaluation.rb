module Evaluation
  class << self

    def remap(depth, data, &block)
      data.each do |i|
        i[:values] = (depth == 0) ? block.call(i[:values]) : remap(depth - 1, i[:values], &block)
      end
    end

  end
end
