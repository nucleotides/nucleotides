module Evaluation
  class << self

    def group(data, keys, &block)
      if keys.empty?
        block.call data
      else
        head, *tail = keys
        grouped = data.group_by do |datum|
          head.inject(datum){|h, k| h[k] }
        end
        grouped.map do |k, v|
          {id: head.join('_'), key: k, values: group(v, tail, &block)}
        end
      end
    end

  end
end
