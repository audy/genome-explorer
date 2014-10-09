class AddStatsHstoreToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :stats, :hstore
  end
end
