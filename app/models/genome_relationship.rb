class GenomeRelationship < ActiveRecord::Base
  belongs_to :genome
  belongs_to :related_genome, class_name: 'Genome', foreign_key:
    :related_genome_id
end
