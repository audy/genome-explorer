class String
  def complement
    self.tr('GATCgatc', 'CTAGctag')
  end
end

class Feature < ActiveRecord::Base
  belongs_to :scaffold
  belongs_to :genome

  def sequence
    i =  -1 + self.start
    j = -1 + self.stop
    seq =  self.scaffold.sequence[i..j]
    if strand == '-'
      seq = seq.reverse.complement
    end
    seq
  end

  def protein_sequence
    Bio::Sequence.auto(self.sequence).translate
  end

  def product
    self.info.match(/product=(.*);/)[1] rescue 'NA'
  end

end
