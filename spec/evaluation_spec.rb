require 'evaluation'

RSpec.describe Evaluation do

  describe "#group" do

    def increment_c(values)
      values.map{|v| v[:c] = v[:c] + 1}
    end

    def data(values = {})
      {a: 1, b: 2, c: 3}.merge(values)
    end

    it "should not group when no keys given" do
      input  = [data]
      output = [4]
      keys   = []
      expect(described_class.group(input, keys, &method(:increment_c))).to eq(output)
    end

    it "should group when one key is given" do
      input  = [data, data(a: 2)]
      output = [{:id=>"a", :key=>1, :values=>[4]}, {:id=>"a", :key=>2, :values=>[4]}]
      keys   = [[:a]]
      expect(described_class.group(input, keys, &method(:increment_c))).to eq(output)
    end

  end

end
