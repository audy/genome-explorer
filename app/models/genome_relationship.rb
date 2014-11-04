class GenomeRelationship < ActiveRecord::Base
  belongs_to :genome
  belongs_to :related_genome, class_name: 'Genome', foreign_key:
    :related_genome_id

  def self.dedup
    grouped = all.group_by do |model|
      [model.genome_id, model.related_genome_id]
    end

    grouped.values.each do |duplicates|
      # remove first one from list
      duplicates.shift

      # if there are any remaining, destroy them
      duplicates.each do |dup|
        dup.destroy
      end
    end

  end
end
