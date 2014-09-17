class Genome < Sequel::Model
  one_to_many :scaffolds
  one_to_many :features

  def fetch_assembly_info_from_ncbi
    resp = `bionode-ncbi search assembly #{self.assembly_id}`
    JSON.parse(resp)
  end

  def before_save
    self.feature_count = Feature.where(genome: self).count
    super
  end
end
