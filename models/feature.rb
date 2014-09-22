class String
  def complement
    self.tr('GATCgatc', 'CTAGctag')
  end
end

class Feature < Sequel::Model
  many_to_one :scaffold
  many_to_one :genome

  def sequence
    i =  -1 + self.start
    j = -1 + self.stop
    seq =  self.scaffold.sequence[i..j]
    if strand == '-'
      seq = seq.reverse.complement
    end
    seq
  end
end
