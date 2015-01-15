class UpdateGenomeRelationshipsPipelineJob
  def perform
    ActiveRecord::Base.transaction {
      # gotta be fresh, gotta *delete* all relationships
      DumpProteinsToFileJob.new('proteins.fasta').perform

      puts 'deleting protein relationships'
      ProteinRelationship.delete_all
      puts 'deleting genome relationships'
      GenomeRelationship.delete_all

      FindRelatedProteinsJob.new.perform
      FindRelatedGenomesJob.new.perform
    }
  end

  def max_run_time
    60 * 60 * 12 # 12 hours in seconds
  end

  def queue_name
    'big'
  end
end
