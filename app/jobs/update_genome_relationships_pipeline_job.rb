class UpdateGenomeRelationshipsPipelineJob
  def perform
    DumpProteinsJob.new('proteins.fasta').perform
    FindRelatedProteinsJob.new.perform
    FindRelatedGenomesJob.new.peform
  end
end
