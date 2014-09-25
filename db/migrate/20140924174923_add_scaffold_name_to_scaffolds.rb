class AddScaffoldNameToScaffolds < ActiveRecord::Migration
  def change
    add_column :scaffolds, :scaffold_name, :string
  end
end
