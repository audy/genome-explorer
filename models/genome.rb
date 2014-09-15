class Genome < Sequel::Model
  one_to_many :scaffolds
end
