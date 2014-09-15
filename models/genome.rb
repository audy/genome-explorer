class Genome < Sequel::Model
  one_to_many :scaffolds
  one_to_many :features

  def before_save
    self.update( feature_count: Feature.where(genome: self).count )
    super
  end
end
