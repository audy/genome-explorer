class AddAvatarToGenomes < ActiveRecord::Migration
  def change
    add_column :genomes, :avatar, :string
  end
end
