module Evaluation
  module Reformat
    class << self

      def default_key_remap(k)
        k.downcase.gsub(' ','_')
      end

      def rename_key(mapping, key)
        remapped = mapping[:id].nil? ? default_key_remap(key) : mapping[:id]
        remapped.to_sym
      end

      def reformat_value(mapping, value)
        if formatters = mapping[:formatters]
          formatters.inject(value) do |x, i|
            f, *args = i
            method(f).call(*args, x)
          end
        else
          value
        end
      end

      def rename(values, mappings)
        remapped = values.map do |(k, v)|
          mapping = mappings.detect{|i| i[:raw] == k}
          raise ArgumentError.new("No mapping found for : '#{k}'.") if mapping.nil?
          [rename_key(mapping, k), reformat_value(mapping, v)]
        end
        Hash[remapped]
      end

      def nearest(n, v)
        v.round(n)
      end

      def one_hundred_minus(v)
        100 - v
      end

      def nano_seconds_to_hours(v)
        v * 2.77778e-13
      end

      def bytes_to_gigabytes(v)
        v / 1e9
      end

      def format(n, v)
        sprintf "%.#{n}f", v
      end

    end
  end
end
