class CreateProteinRelationships < ActiveRecord::Migration
  def change
    create_table :protein_relationships, id: false do |t|
      t.timestamps
    end
  end
end
