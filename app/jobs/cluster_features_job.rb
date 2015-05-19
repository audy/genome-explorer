class ClusterFeaturesJob

  def initialize kwargs = {}
    @input = kwargs[:input] || fail 'must provide input'
    @identity = kwargs[:identity] || fail 'must provide identity'
  end

  def perform
    cmd = %{
    # sort by length
    uclust \
      --sort #{@input} \
      --output sorted.fasta

    # cluster
    uclust \
      --input sorted.fasta \
      --uc clusters.#{@identity}.uc \
      --id #{@identity}
    }
  end

  def queue_name
    'big'
  end

end
