class Genome
  include DataMapper::Resource

  property :id, Serial
  property :name, String, index: true

  has n, :scaffolds

  def predict_features!
    features = predict_features(self)
    features.map &:save
  end
end
