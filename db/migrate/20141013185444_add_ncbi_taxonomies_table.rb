class AddNcbiTaxonomiesTable < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.integer :parent_id
      t.string :name
      t.integer :rank
    end
  end
end
