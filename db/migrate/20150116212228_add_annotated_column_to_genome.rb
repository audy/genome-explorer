class AddAnnotatedColumnToGenome < ActiveRecord::Migration
  def change
    add_column :genomes, :annotated, :boolean, default: false
  end
end
