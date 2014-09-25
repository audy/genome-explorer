class AddNcbiMetadataToGenomes < ActiveRecord::Migration
  def up
    add_column :genomes, :ncbi_metadata, :hstore
  end

  def down
    remove_column :genomes, :ncbi_metadata
  end
end
