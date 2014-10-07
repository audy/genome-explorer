class AddHstoreToProteinRelationships < ActiveRecord::Migration
  def change
    add_column :protein_relationships, :info, :hstore
  end
end
