class AddIndexToProteinrelationships < ActiveRecord::Migration
  def change
    add_index :protein_relationships, :feature_id
    add_index :protein_relationships, :related_feature_id
  end
end
