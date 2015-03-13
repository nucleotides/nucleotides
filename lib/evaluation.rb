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

    def descend(data, depth, &block)
      depth == 0 ? yield(data) : data.each{|datum| descend(datum[:values], depth - 1, &block) }
    end

    def enumerator(data, depth)
      values = []
      descend(data, depth) do |i|
        values << i
      end
      values.each
    end

  end
end
