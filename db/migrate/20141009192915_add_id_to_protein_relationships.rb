class AddIdToProteinRelationships < ActiveRecord::Migration
  def change
    add_column :protein_relationships, :id, :primary_key
  end
end
