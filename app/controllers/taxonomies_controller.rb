class TaxonomiesController < ApplicationController

  def index
    @taxonomies = Taxonomy.first(10) #.paginate(page: params[:page], per_page: 25)
  end

  def show
    @taxonomy = Taxonomy.find params[:id]
  end

end
