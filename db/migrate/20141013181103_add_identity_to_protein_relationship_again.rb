class AddIdentityToProteinRelationshipAgain < ActiveRecord::Migration
  def change
    add_column :protein_relationships, :identity, :integer
  end
end
