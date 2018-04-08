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

  after_create do
    self.delay(queue: 'local').build
  end

  def organism
    self[:ncbi_metadata]['organism'] rescue 'Unknown'
  end

  def create_avatar
    CreateGenomeAvatarJob.new(self.id).perform
  end

  def build kwargs = {}
    Genome.transaction {
      CreateGenomeAvatarJob.new(self.id).perform
    }
  end

  # in the progress of re-building graph features
  # for now, genomes are just related
  def in_graph?
    false
  end

  def self.search(search)
    if search
      where [ 'lower(organism) LIKE ?', "%#{search.downcase}%" ]
    else
      all
    end
  end

end
