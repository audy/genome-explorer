class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :start
      t.integer :stop
      t.string :strand
      t.string :feature_type # can't be called type!
      t.string :info
      t.references :scaffold, index: true
      t.integer :frame
      t.string :source
      t.float :score

      t.timestamps
    end
  end
end
