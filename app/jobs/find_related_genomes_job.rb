class FindRelatedGenomesJob

  def perform
    # - pairwise comparison of all genomes to determine the number of
    #   shared/similar proteins. 260^2 > 50k. A lot of comparisons, queries.
    #
    # - similar proteins can have different levels of identity which needs to be
    #   taken into account but isn't right now. at least 60%. Pretty high for
    #   proteins.
    #
    # - Try to memoize stuff to avoid redundant DNA lookups
    
    related_features_counter = Hash.new { |h, k| h[k] = Hash.new { |x, y| x[y] = 0 } }

    ActiveRecord::Base.logger.level = 1

    pbar = ProgressBar.new 'counting', ProteinRelationship.count

    ProteinRelationship.find_each do |relationship|
      pbar.inc
      l = relationship.feature.genome.id
      r = relationship.related_feature.genome.id
      related_features_counter[l][r] += 1
    end

    pbar.finish

    pr = []

    related_features_counter.each_pair do |genome_id, v|
      v.each_pair do |related_genome_id, related_features_count|
        pr << [ genome_id, related_genome_id, related_features_count ]
      end
    end

    GenomeRelationship.import [:genome_id, :related_genome_id,
                               :related_features_count], pr

  end

end
