class SetupProteinFamilyRelation < ActiveRecord::Migration
  def change
    change_table :protein_relationships do |t|
      t.column :feature_id, :integer
      t.column :related_feature_id, :integer
    end
  end
end
