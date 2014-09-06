class Genome
  include DataMapper::Resource

  property :id, Serial

  property :file_path, String, required: true, length: 255
  validates_uniqueness_of :file_path

  has n, :annotations
  has n, :scaffolds

  def predict_features!
    features = predict_features(self)
    features.map &:save
  end

  def name
    File.basename(self.file_path).tr('_', ' ')
  end
end
