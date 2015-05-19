# load feature clusters from uclust output
# dumps existing clusters every time
#

class LoadFeatureClustersJob
  def initialize(_kwargs = {})
  end

  def perform
  end

  def queue_name
    'big'
  end

  private

  def parse_uclust_line(line)
    if line =~ /^HS/
      line = line.strip.split("\t")
      cluster_id = Integer line[1]
      protein_id = Integer line[8]
    else
      nil
    end
  end

  def parse_uclust(_handle)
  end
end
