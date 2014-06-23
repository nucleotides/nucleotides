require 'helper'
require 'data_processor'

EXAMPLE_RESULT_FILE = <<END
Assembly	contigs
# contigs (>= 0 bp)	632
# contigs (>= 1000 bp)	113
Total length (>= 0 bp)	4587624
Total length (>= 1000 bp)	4536699
# contigs	123
Largest contig	281515
Total length	4543637
Reference length	4575057
GC (%)	62.55
Reference GC (%)	62.52
N50	89985
NG50	89985
N75	42351
NG75	42351
L50	15
LG50	15
L75	34
LG75	34
# misassemblies	0
# misassembled contigs	0
Misassembled contigs length	0
# local misassemblies	9
# unaligned contigs	6 + 0 part
Unaligned length	26258
Genome fraction (%)	98.552
Duplication ratio	1.002
# N's per 100 kbp	4.62
# mismatches per 100 kbp	8.52
# indels per 100 kbp	0.49
Largest alignment	281515
NA50	89985
NGA50	89985
NA75	42351
NGA75	42351
LA50	15
LGA50	15
LA75	34
LGA75	34
END

describe DataProcessor do
  include DataProcessor

  describe "#parse_result" do

    subject do
      parse_result EXAMPLE_RESULT_FILE
    end

   its([:n_contigs_gt_1000]){ should eq(113) }
   its([:genome_fraction]){ should eq(98.552) }
   its([:n50]){ should eq(89985) }
   its([:l50]){ should eq(15) }
   its([:mismatches_per_100k]){ should eq(8.52) }
   its([:ns_per_100k]){ should eq(4.62) }
   its([:indels_per_100k]){ should eq(0.49) }

  end

end

