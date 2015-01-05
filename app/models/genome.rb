require 'json'
require 'tempfile'
require 'zlib'

class Genome < ActiveRecord::Base
  has_many :scaffolds
  has_many :features

  validates :assembly_id,
    numericality: { only_integer: true },
    presence: true,
    uniqueness: true

  mount_uploader :avatar, AvatarUploader

  # genome friends
  has_many :genome_relationships
  has_many :related_genomes, through: :genome_relationships
  has_many :inverse_genome_relationships, class_name: 'GenomeRelationship',
    foreign_key: :related_genome_id
  has_many :inverse_related_genomes, through: :inverse_genome_relationships,
    source: :genome

  after_create do
    self.delay(queue: 'local').build
  end

  def build
    CreateGenomeAvatarJob.new(self.id).perform
    PullGenomeFromNCBIJob.new(self.id).perform
    UpdateGenomeStatsJob.new(self.id).perform
  end

  def self.search(search)
    if search
      where [ 'lower(organism) LIKE ?', "%#{search.downcase}%" ]
    else
      all
    end
  end

end
