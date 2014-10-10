class GenomeRelationshipsController < ApplicationController

  def index

    respond_to do |format|
      format.json do

        genome_relationships = GenomeRelationship.all
        genomes = Genome.all

        genomes_list = []

        nodes = genomes.map do |genome|
          genomes_list << genome.id
          { name: genome.organism, group: genome.organism.split.first }
        end

        index = Hash[genomes_list.map.with_index.to_a] 

        links = genome_relationships.map do |rel|
          { source: index[rel.genome_id], target: index[rel.related_genome_id], value: rel.related_features_count }
        end

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
