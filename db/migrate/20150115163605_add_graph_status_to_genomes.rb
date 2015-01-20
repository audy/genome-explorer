class AddGraphStatusToGenomes < ActiveRecord::Migration
  def change
    add_column :genomes, :in_graph, :boolean, default: false
  end
end
