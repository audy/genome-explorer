class AddIdToGenomeRelationships < ActiveRecord::Migration
  def change
    add_column :genome_relationships, :id, :primary_key
  end
end
