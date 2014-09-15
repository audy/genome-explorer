class Genome < Sequel::Model
  one_to_many :scaffolds
  one_to_many :features

  def before_save
    self.feature_count = self.features.size
    super
  end
end
