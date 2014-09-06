class Feature
  include DataMapper::Resource
  belongs_to :annotation

  property :id, Serial

  property :start, Integer
  property :stop, Integer
  property :score, Float
  property :strand, Enum[:forward, :reverse]
  property :info, String, length: 1024
  property :type, Enum[:CDS, :exon, :gene, :rRNA, :region, :repeat_region,
                       :tRNA, :STS, :ncRNA, :gap, :transcript, :binding_site,
                       :promoter, :tmRNA]

  def sequence
    self.scaffold.sequences
  end
end
