class CreateGenomeRelationships < ActiveRecord::Migration
  def change
    create_table :genome_relationships, id: false do |t|
      t.column :genome_id, :integer, index: true
      t.column :related_genome_id, :integer, index: true
      t.column :related_features_count, :integer
    end
  end
end
