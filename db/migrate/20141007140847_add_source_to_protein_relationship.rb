class AddSourceToProteinRelationship < ActiveRecord::Migration
  def change
    # store the source of a protein relationship. Should probably build another
    # table in the future so that I can hold many different protein relationship
    # tables. I could also build separate tables every time I build protein
    # relationships
    add_column :protein_relationships, :source, :string, index: true
  end
end
