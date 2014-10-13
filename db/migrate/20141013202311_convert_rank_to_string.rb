class ConvertRankToString < ActiveRecord::Migration
  def change
    change_column :taxonomies, :rank, :string
  end
end
