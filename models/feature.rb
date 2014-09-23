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

  def protein_sequence
    Bio::Sequence.auto(self.sequence).translate
  end

  def product
    self.info.match(/product=(.*);/)[1] rescue 'NA'
  end

  def from_gff_line line
    self.new(parse_gff_line(line))
  end

  def similar
    hits = App::DB[:similarities].where(source_id: self.id)
    hits.map do |hit|
      Feature[hit[:target_id]]
    end
  end

end
