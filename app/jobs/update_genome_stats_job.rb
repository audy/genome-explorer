UpdateGenomeStatsJob = Struct.new(:id) do

  def perform
    @genome = Genome.find(self.id)
    @genome[:stats] = { total_features: @genome.features.count,
                    total_scaffolds: @genome.scaffolds.count,
                    genome_size: @genome.scaffolds.map { |x| x.sequence.size }.inject(:+),
                    total_proteins: @genome.features.where(feature_type: 'CDS').count,
                    shared_proteins: @genome.features.where(feature_type: 'CDS').count{ |x| x.related_features.size > 1 ? 1 : 0 }
    }
    @genome.save
  end

end
