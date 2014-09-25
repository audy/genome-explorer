class CreateScaffolds < ActiveRecord::Migration
  def change
    create_table :scaffolds do |t|
      t.text :sequence
      t.references :genome, index: true

      t.timestamps
    end
  end
end
