class RemoveGenomeAndProteinRelationships < ActiveRecord::Migration
  def up
    drop_table :genome_relationships
    drop_table :protein_relationships
  end
end
