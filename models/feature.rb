class Feature < Sequel::Model
  many_to_one :scaffold

  def sequence
    self.scaffold.sequences
  end
end
