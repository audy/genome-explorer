class GenomeRelationshipsController < ApplicationController

  def index

    respond_to do |format|
      format.json do
        # a big mess.
        
        @min_related = Integer(params[:min_related] || 10)

        # find all genome relationships where genome_id is params[:genome_id]
        # then find all genome relationships whose genome_id is in the related
        # genome ids.
        genome_relationships = 
          unless params[:genome_id].nil? || params[:genome_id].empty?
            # find all genomes related to this genome
            genomes_related = GenomeRelationship.
              where(genome: params[:genome_id]).
              where('related_features_count > ?', @min_related).
              all

            # find relationships within genomes that are related to this genome
            # todo: it would be cool to be able to specify depth and build this
            # graph iteratively up to n levels.
            related_relationships =
              GenomeRelationship.
              where(genome_id: genomes_related.map(&:related_genome_id)).
              where('related_features_count > ?', @min_related).
              all
            # combine, use to build graph
            genomes_related + related_relationships
          else
            GenomeRelationship.all
          end


        # get a list of all genomes included in the genome relationships
        # (this list is highly redundant so uniq it, also sometimes there are
        # nils so just remove them).
        genomes = (genome_relationships.map(&:genome) +
                   genome_relationships.map(&:related_genome)).uniq.compact

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
          if count < @min_related
            nil
          elsif source.nil? or target.nil?
            nil
          else
            { source: source , target: target, value: count }
          end
        end.compact

        dat = { nodes: nodes, links: links }

        render json: dat
      end
      format.html {}
    end
  end

  def show
    @genome_relationship = GenomeRelationship.first
  end

end
