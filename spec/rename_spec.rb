require 'evaluation/rename'

RSpec.describe Evaluation::Rename do

    it "should rename the variables according to given map" do
      values  = {"value a" => 1, "value b" => 2.0}
      mapping = [{raw: "value a", id: "val_a"}, {raw: "value b", id: "val_b"}]
      output = described_class.rename(values, mapping)
      expect(output).to eq({val_a: 1, val_b: 2.0})
    end

    it "should use default remap when ':id' is missing" do
      values  = {"value a" => 1, "Value b" => 2.0}
      mapping = [{raw: "value a", id: :val_a}, {raw: "Value b"}]
      output = described_class.rename(values, mapping)
      expect(output).to eq({val_a: 1, value_b: 2.0})
    end

    it "should raise an error if no remap is present" do
      values  = {"value a" => 1}
      mapping = [{}]
      expect(lambda{ described_class.rename(values, mapping) }).to \
        raise_error(ArgumentError, "No mapping found for : 'value a'.")
    end

end
