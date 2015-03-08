require 'evaluation'

RSpec.describe Evaluation do

  describe "#remap" do

    def increment(a)
      a.map{|i| i + 1}
    end

    def data(values)
      {id: "id", key: "key", values: values}
    end

    it "remap a single-level data structure" do
      expect(described_class.remap(0, [data([1,2,3])], &method(:increment))).to \
        eq([data([2,3,4])])
    end

    it "remap a two-level data structure" do
      input = [data([data([1,2,3]), data([1,2,3])])]
      expect(described_class.remap(1, input, &method(:increment))).to \
        eq([data([data([2,3,4]), data([2,3,4])])])
    end

  end

end
