Sequel.migration do

  up do
    
    create_table :genomes do
      primary_key :id
      Integer :assembly_id, null: false
    end

    create_table :scaffolds do
      primary_key :id
      Integer :genome_id
      String :sequence
    end

    create_table :features do
      primary_key :id

      Integer :scaffold_id

      Integer :start
      Integer :stop
      String :source
      Float :score
      String :strand 
      String :info
      String :type

    end

  end

  down do
    drop_table :genomes
  end

end
