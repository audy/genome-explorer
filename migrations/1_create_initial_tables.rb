Sequel.migration do

  up do
    
    create_table :genomes do
      primary_key :id

      Integer :assembly_id, unique: true

      Integer :feature_count, default: 0
      String :organism
    end

    create_table :scaffolds do
      primary_key :id

      foreign_key :genome_id, :genomes

      String :sequence
      String :name
    end

    create_table :features do
      primary_key :id

      foreign_key :genome_id, :genomes
      foreign_key :scaffold_id, :scaffolds

      Integer :start
      Integer :stop
      Integer :frame
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
