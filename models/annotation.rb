class Annotation
  include DataMapper::Resource

  property :id, Serial
  property :source, String

  has n, :features

  belongs_to :genome
end
