class ProteinRelationship < ActiveRecord::Base
  belongs_to :feature
  belongs_to :related_feature, class_name: 'Feature', foreign_key: :related_feature_id
end
