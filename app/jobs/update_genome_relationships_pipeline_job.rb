class UpdateGenomeRelationshipsPipelineJob
  def perform
    ActiveRecord::Base.transaction {
      DumpProteinsToFileJob.new('proteins.fasta').perform
      # start fresh each time
      ProteinRelationship.destroy_all
      GenomeRelationship.destroy_all
      FindRelatedProteinsJob.new.perform
      FindRelatedGenomesJob.new.peform
    }
  end

  def max_run_time
    60 * 60 * 12 # 12 hours in seconds
  end
end
