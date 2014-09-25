class ChangeDataTypeToStringForFeatureInfo < ActiveRecord::Migration
  def change
    change_table :features do |t|
      t.change :info, :text
    end
  end
end
