class FeaturesController < ApplicationController

  def show
    @feature = Feature.find params[:id]
    related = @feature.find_similar_proteins
    @related_features = related.keys.map { |x| Feature.find(x) }.compact
  end

end
