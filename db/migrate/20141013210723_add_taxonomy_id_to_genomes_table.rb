class AddTaxonomyIdToGenomesTable < ActiveRecord::Migration
  def change
    add_column :genomes, :taxonomy_id, :integer
  end
end
