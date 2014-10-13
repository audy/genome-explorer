class UpdateGenomeRelationshipsPipelineJob
  def perform
    DumpProteinsJob.new('proteins.fasta').perform
    FindRelatedProteinsJob.new.perform
    FindRelatedGenomesJob.new.peform
  end

  def max_run_time
    60 * 60 * 12 # 12 hours in seconds
  end
end
