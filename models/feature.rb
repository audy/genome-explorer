class Feature < Sequel::Model
  many_to_one :scaffold
  many_to_one :genome

  def sequence
    frame = frame.nil? ? 0 : frame
    i =  -1 + self.start + frame
    j = -1 + self.stop + frame
    seq =  self.scaffold.sequence[i..j]
    seq
  end
end
