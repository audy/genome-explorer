class ChangeScaffoldSequenceToText < ActiveRecord::Migration
  def change
    change_table :scaffolds do |t|
      t.change :sequence, :text
    end
  end
end
