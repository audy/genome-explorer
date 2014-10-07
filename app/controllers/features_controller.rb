class FeaturesController < ApplicationController

  def show
    @feature = Feature.find params[:id]
    @related_features = @feature.related_features.all
  end

end
