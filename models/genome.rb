class Genome < Sequel::Model
  one_to_many :scaffolds
  one_to_many :features
end
