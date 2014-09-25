class FeaturesController < ApplicationController

  def show
    @feature = Feature.find params[:id]
    @related_features = @feature.related_features.where(feature_type: 'CDS')
  end

end
