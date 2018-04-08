class GenomesController < ApplicationController

  def index
    @genomes =
      Genome.
      search(params[:search]).
      order(id: :desc).
      paginate(page: params[:page], per_page: 25)
  end

  def new
    @genome = Genome.new
  end

  def show
    @genome = Genome.find params[:id]

    @features = @genome.features.proteins.
      order(:start).
      paginate(page: params[:features_page], per_page: 10)
  end

  def create
    @genome = Genome.new(genome_params)
    if @genome.save
      redirect_to genomes_path
    else
      render 'new'
    end
  end

  def edit
    @genome = Genome.find(params[:id])
  end

  def update
    @genome = Genome.find(params[:id])

    if @genome.update(genome_params)
      redirect_to @genome
    else
      render 'edit'
    end
  end

  def destroy
    @genome = Genome.find(params[:id])
    @genome.destroy

    redirect_to genomes_path
  end

  private

  def genome_params
    params.require(:genome).permit(:assembly_id)
  end
end
