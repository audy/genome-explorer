class FeaturesController < ApplicationController

  def show
    @feature = Feature.find params[:id]
    @related_features = @feature.
      related_features.
      where.not(genome: nil). # filter out orphan features
      all
  end

end
