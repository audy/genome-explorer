# this job builds the entire genomes graph from scratch based on the entire
# features graph.
#
# It needs to be altered to accept a list of features to build a graph from.
# Alternatively, I could query the database to only use feature relationships
# created after a certain time. `created_at` gets filled in before the
# transaction ends so this is possible.

class FindRelatedGenomesJob < Struct.new(:feature_ids)

  def perform opts = {}

    # optionally take a list of features to use, otherwise, use all of 'em
    # XXX what if the list of features is really huge?
    @features =
      if self.feature_ids.nil?
        Feature.proteins
      else
        Feature.where(id: self.feature_ids)
      end

    puts "using #{@features.count} features"

    # by default, use all protein-relationships.
    # if a list of features was provided, use only their relationships.
    if self.feature_ids.nil?
      puts 'using all protein relationships'
      @relations = ProteinRelationship.all
    else
      # only use relations belonging to those features
      # XXX potentially bad for SQL database? Check logs for queries. Maybe not
      # since using find_each.
      @relations = ProteinRelationship.where(
        'feature_id IN (?) OR related_feature_id IN (?)',
        self.feature_ids,
        self.feature_ids
      )
      puts "using #{@relations.count} protein relationships"
    end

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
    feature_to_genome_memo = Hash.new { |h, k| h[k] = Feature.find(k).genome_id }

    if opts[:progress]
      pbar = ProgressBar.new 'memoizing features', @features.count
    end

    # just build the hash
    @features.find_each do |feature|
      pbar.inc if opts[:progress]
      feature_to_genome_memo[feature.id] = feature.genome_id
    end

    pbar.finish if opts[:progress]

    if opts[:progress]
      pbar = ProgressBar.new('counting', @relations.count)
    end

    @relations.find_each do |relationship|
      pbar.inc if opts[:progress]
      l = feature_to_genome_memo[relationship.feature_id]
      r = feature_to_genome_memo[relationship.related_feature_id]
      related_features_counter[l][r] += 1
    end

    pbar.finish if opts[:progress]

    pr = []

    related_features_counter.each_pair do |genome_id, v|
      v.each_pair do |related_genome_id, related_features_count|
        pr << [ genome_id, related_genome_id, related_features_count ]
      end
    end

    # does this need to be in a transaction?
    GenomeRelationship.transaction {
      # GenomeRelationship.destroy_all
      # dont assume building relationships from scratch
      GenomeRelationship.import [:genome_id, :related_genome_id,
                                :related_features_count], pr
    }

    puts "imported #{pr.count} new genome relationships"

  end

end
