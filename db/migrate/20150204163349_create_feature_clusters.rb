class CreateFeatureClusters < ActiveRecord::Migration
  def change

    create_table :feature_clusters do |t|
      t.timestamps
    end

  end
end
