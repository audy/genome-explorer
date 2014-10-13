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


    # memoize feature_id -> genome_id to avoid repeating SQL queries
    feature_to_genome_memo = Hash.new #{ |h, k| h[k] = Feature.find(k).genome_id }

    pbar = ProgressBar.new 'memoizing features', Feature.where(feature_type:
                                                               'CDS').count

    # just build the hash
    Feature.where(feature_type: 'CDS').find_each do |feature|
      pbar.inc
      feature_to_genome_memo[feature.id] = feature.genome_id
    end

    pbar.finish

    pbar = ProgressBar.new 'counting', ProteinRelationship.count

    ProteinRelationship.find_each do |relationship|
      pbar.inc
      l = feature_to_genome_memo[relationship.feature_id]
      r = feature_to_genome_memo[relationship.related_feature_id]
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
