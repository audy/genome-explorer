class AddGenomeToFeatures < ActiveRecord::Migration
  def change
    add_reference :features, :genome, index: true
  end
end
