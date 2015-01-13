class Scaffold < ActiveRecord::Base
  belongs_to :genome
  has_many :features, dependent: :destroy
end
