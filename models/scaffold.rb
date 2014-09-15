class Scaffold < Sequel::Model
  many_to_one :genome
  one_to_many :features
end
