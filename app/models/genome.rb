require 'json'
require 'tempfile'
require 'zlib'

class Genome < ActiveRecord::Base
  has_many :scaffolds, dependent: :destroy
  has_many :features, dependent: :destroy

  validates :assembly_id,
    numericality: { only_integer: true },
    presence: true,
    uniqueness: true

  mount_uploader :avatar, AvatarUploader

  # genome friends
  has_many :genome_relationships, dependent: :destroy

  has_many :related_genomes, through: :genome_relationships

  has_many :inverse_genome_relationships, class_name: 'GenomeRelationship',
    foreign_key: :related_genome_id
  has_many :inverse_related_genomes, through: :inverse_genome_relationships,
    source: :genome

  after_create do
    self.delay(queue: 'local').build
  end

  def annotated?
    self.annotated
  end

  def organism
    self[:ncbi_metadata]['organism'] rescue 'Unknown'
  end

  def pull_metadata_from_ncbi
    self[:ncbi_metadata] = JSON.parse(`bionode-ncbi search assembly #{self[:assembly_id]}`)
  end

  def update_metadata!
    self.pull_metadata_from_ncbi
    self.save!
  end

  def added_to_graph?
    self.in_graph
  end

  def create_avatar
    CreateGenomeAvatarJob.new(self.id).perform
  end

  def build kwargs = {}
    Genome.transaction {
      CreateGenomeAvatarJob.new(self.id).perform
      PullGenomeFromNCBIJob.new(self.id, fna_path: kwargs[:fna_path],
                                         gff_path: kwargs[:gff_path]).perform
      UpdateGenomeStatsJob.new(self.id).perform
      self.update! annotated: true
    }
  end

  def self.search(search)
    if search
      where [ 'lower(organism) LIKE ?', "%#{search.downcase}%" ]
    else
      all
    end
  end

end
