# adds column assembly_data to Genome. This column is for storing JSON
# serialized info about the genome from NCBI.

Sequel.migration do

  up do
    add_column :genomes, String, :assembly_data
  end

  down do
    remove_column :genomes, String, :assembly_data
  end

end
