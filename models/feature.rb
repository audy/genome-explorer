class Feature < Sequel::Model
  many_to_one :scaffold
  many_to_one :genome

  def sequence
    self.scaffold.sequences
  end
end
