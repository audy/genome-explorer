class String
  def complement
    self.tr('GATCgatc', 'CTAGctag')
  end
end

class Feature < ActiveRecord::Base
  belongs_to :scaffold
  belongs_to :genome

  has_many :protein_relationships
  has_many :related_features, through: :protein_relationships

  has_many :inverse_protein_relationships, class_name: 'ProteinRelationship',
    foreign_key: :related_feature_id

  has_many :inverse_related_features, through: :inverse_protein_relationships,
    source: :feature

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
