class AddSummaryStatsToGenome < ActiveRecord::Migration
  def up
    add_column :genomes, :stats, :hstore
  end

  def down
    remove_column :genomes, :stats
  end
end
