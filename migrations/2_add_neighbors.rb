Sequel.migration do

  up do

    create_table :similarities do
      primary_key :id
      foreign_key :source_id
      foreign_key :target_id
    end

  end

  down do
    drop_table :similarities
  end

end
