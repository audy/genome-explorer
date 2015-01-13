class GenomeRelationshipsController < ApplicationController

  def index
    respond_to do |format|

      # generate the graph and return JSON
      format.json do
        # a big mess.
        genome = Genome.find(params[:genome_id])
        if genome.nil?
          render json: { error: "genome #{params[:genome_id]} doesn't exist" }
        else
          graph = Graphs::Builder.new.build(genome, min_related: 0)
          render json: graph
        end
      end

      # just render the HTML, JavaScript will get JSON data
      # and update the page
      format.html {}
    end
  end

  def show
    @genome_relationship = GenomeRelationship.first
  end

end
