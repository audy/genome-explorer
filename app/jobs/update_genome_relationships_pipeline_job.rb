class UpdateGenomeRelationshipsPipelineJob
  def perform
    ActiveRecord::Base.transaction {
      DumpProteinsToFileJob.new('proteins.fasta').perform
      FindRelatedProteinsJob.new.perform
      FindRelatedGenomesJob.new.peform
    }
  end
end
