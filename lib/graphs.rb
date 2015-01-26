#
# this module is poorly named. It should be called something like GraphViewer or
# GraphLense as it isn't really constructing a graph but providing different
# representations of the GenomeRelationship table.
#
# This could also be generalized to provide views of the FeatureRelationship
# table.
#
# This module could be modified to provide different lenses on relationships
# tables.
#
# I should read a few books on design patterns and rails
#
# --austin (Tue Jan 13 15:50:44 EST 2015)

module Graphs

  class Builder

  def build seed_genome, min_related: 0

    # find all genome to a given genome then find all genome relationships whose
    # genome_id is in the related genome ids.
    genome_relationships = 

      # todo make sure genome actually exists before getting this far
      unless seed_genome.id.nil?
        # find all genomes related to this genome
        related_to_seed = GenomeRelationship.
          where(genome: seed_genome).
          all

        # find relationships within genomes that are related to the seed genome
        # todo: it would be cool to be able to specify depth and build this
        # graph iteratively up to n levels.

        # list of ids of genomes related to seed genome
        related_ids = related_to_seed.map(&:related_genome_id)

        related_relationships =
          GenomeRelationship.
          where(genome_id: related_ids).
          first(3)

        # combine, use to build graph
        related_to_seed + related_relationships
      else
        GenomeRelationship.all
      end

    # cull the genome relationships list so that for each genome, take only the
    # nearest genome

    # get a list of all genomes included in the genome relationships
    # (this list is highly redundant so uniq it, also sometimes there are
    # nils so just remove them).
    genomes = (genome_relationships.map(&:genome) +
                genome_relationships.map(&:related_genome)).uniq.compact

    # todo: split this into a new method called prepare_graph_for_d3 or
    # something.

    # build graph nodes
    # also make a 0-based indexed array of genomes (for referencing the
    # genomes in the links)
    genomes_list = []
    nodes = genomes.map do |genome|
      genomes_list << genome.id
      { name: genome.organism, group: genome.organism.split[1] }
    end

    # convert the 0-indexed array into a hash, so we can reference the
    # genomes by their 0-based index
    index = Hash[genomes_list.map.with_index.to_a] 

    # build the links { source:, target:, value: }
    # where source and target are the 0-based index of the genome in
    # genomes_list (which got converted to index hash).
    links = genome_relationships.map do |rel|
      count = rel.related_features_count
      source = index[rel.genome_id]
      target = index[rel.related_genome_id]
      if count < min_related
        nil
      elsif source.nil? or target.nil?
        nil
      else
        { source: source , target: target, value: count }
      end
    end.compact

    return { nodes: nodes, links: links }

  end # def
  end # class
end # module
