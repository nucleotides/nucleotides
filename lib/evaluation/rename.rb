module Evaluation
  module Rename
    class << self

      def default_key_remap(k)
        k.downcase.gsub(' ','_')
      end

      def rename(values, mappings)
        remapped = values.map do |(key, value)|
          m = mappings.detect{|i| i[:raw] == key}
          raise ArgumentError.new("No mapping found for : '#{key}'.") if m.nil?

          remapped = m[:id].nil? ? default_key_remap(key) : m[:id]
          [remapped.to_sym, value]
        end
        Hash[remapped]
      end

    end
  end
end
