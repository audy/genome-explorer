class Annotation
  include DataMapper::Resource

  has n, :features
  belongs_to :scaffold

  property :id, Serial
  property :source, String


  belongs_to :genome
end
