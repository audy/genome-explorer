class AddSourceFilesToGenome < ActiveRecord::Migration
  def change
    add_column :genomes, :gff_file, :string
    add_column :genomes, :fna_file, :string
  end
end
