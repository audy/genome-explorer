class AddMatrixIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :matrix_id, :string
  end
end
