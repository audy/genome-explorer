class UpdateFeatureStatsJob

  def perform
    Feature.transaction do
      Feature.find_each do |feature|
        n_related_features = feature.related_features.count
        feature.update(stats: { related_features: n_related_features })
      end
    end
  end

end
