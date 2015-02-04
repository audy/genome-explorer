class AddClusterRefToFeatures < ActiveRecord::Migration
  def change
    add_reference :features, :feature_cluster, index: true
  end
end
