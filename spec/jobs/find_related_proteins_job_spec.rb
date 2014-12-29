require 'spec_helper'

require 'tempfile'

# this test will fail on Travis.

describe FindRelatedProteinsJob do

  before (:all) { IO.write(TMP_FILE, SEQUENCES) }

  let (:job) { FindRelatedProteinsJob.new(input: TMP_FILE.path) }

  it 'can find releated proteins' do
    job.perform
    ProteinRelationship.count.should_not eq(0)
    # two-way relationship for each pair of features = 8 relationships
    # (yes I know that is inefficients I should fix this at some point)
    ProteinRelationship.count.should eq(8)
  end

end

# data:
# (AA sequences should match others with same header)

TMP_FILE = Tempfile.new('proteins')

SEQUENCES=%s{>1
MKTKLFLAAVAVTFSFAMMSCTGNKTTNAASEGEETTVETVEAVVETDSCCQAKDSCATACDKKADCAEKKECCDKK*
>1
MKTKLFLAAVAVTFSFAMMSCTGNKTTNAASEGEETTVETVEAVVETDSCCQAKDSCATACDKKADCAEKKECCDKK*
>2
MKRVLCPKCENYLYFDETKYSEGQSLVFECEHCGKQFSIRLGKSKVKALRKEENLEEEAESHKEEFGYITVIENVFGFKQLLPLQEGDNVIGRRCVGTNINTPIESGDMSMDRRHCIINIKRNKQGKLVYTLRDAPSLTGTFLMNEILGDKDRVHIEDGAIVTIGATTFILHTAEQE*
>2
MKRVLCPKCENYLYFDETKYSEGQSLVFECEHCGKQFSIRLGKSKVKALRKEENLEEEAESHKEEFGYITVIENVFGFKQLLPLQEGDNVIGRRCVGTNINTPIESGDMSMDRRHCIINIKRNKQGKLVYTLRDAPSLTGTFLMNEILGDKDRVHIEDGAIVTIGATTFILHTAEQE*
}
