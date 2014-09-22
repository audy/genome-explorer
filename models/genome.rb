class Genome < Sequel::Model
  one_to_many :scaffolds
  one_to_many :features

  def before_save
    self.feature_count = Feature.where(genome: self).count
    super
  end

  def fetch_ncbi_info
    resp = `bionode-ncbi search assembly #{self.assembly_id}`
    dat = JSON.parse(resp)
  end

  def update_info_from_ncbi!
    self.update organism: fetch_ncbi_info['organism']
  end

end
