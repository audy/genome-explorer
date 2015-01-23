class DropOrganismFromGenome < ActiveRecord::Migration
  def change
    remove_column :genomes, :organism
  end
end
