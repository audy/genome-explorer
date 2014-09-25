class CreateGenomes < ActiveRecord::Migration
  def change
    create_table :genomes do |t|
      t.integer :assembly_id
      t.string :organism

      t.timestamps
    end
  end
end
