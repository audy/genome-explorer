class String
  def complement
    self.tr('GATCgatc', 'CTAGctag')
  end
end

# copy/pasted from https://github.com/bioruby/bioruby/blob/5f3569faaf89ebcd2b2cf9cbe6b3c1f0544b2679/lib/bio/data/codontable.rb
CODON_TABLE = {
      'ttt' => 'F', 'tct' => 'S', 'tat'	=> 'Y', 'tgt' => 'C',
      'ttc' => 'F', 'tcc' => 'S', 'tac'	=> 'Y', 'tgc' => 'C',
      'tta' => 'L', 'tca' => 'S', 'taa'	=> '*', 'tga' => '*',
      'ttg' => 'L', 'tcg' => 'S', 'tag'	=> '*', 'tgg' => 'W',
      'ctt' => 'L', 'cct' => 'P', 'cat'	=> 'H', 'cgt' => 'R',
      'ctc' => 'L', 'ccc' => 'P', 'cac'	=> 'H', 'cgc' => 'R',
      'cta' => 'L', 'cca' => 'P', 'caa'	=> 'Q', 'cga' => 'R',
      'ctg' => 'L', 'ccg' => 'P', 'cag'	=> 'Q', 'cgg' => 'R',
      'att' => 'I', 'act' => 'T', 'aat'	=> 'N', 'agt' => 'S',
      'atc' => 'I', 'acc' => 'T', 'aac'	=> 'N', 'agc' => 'S',
      'ata' => 'I', 'aca' => 'T', 'aaa'	=> 'K', 'aga' => 'R',
      'atg' => 'M', 'acg' => 'T', 'aag'	=> 'K', 'agg' => 'R',
      'gtt' => 'V', 'gct' => 'A', 'gat'	=> 'D', 'ggt' => 'G',
      'gtc' => 'V', 'gcc' => 'A', 'gac'	=> 'D', 'ggc' => 'G',
      'gta' => 'V', 'gca' => 'A', 'gaa'	=> 'E', 'gga' => 'G',
      'gtg' => 'V', 'gcg' => 'A', 'gag'	=> 'E', 'ggg' => 'G',
}

class Feature < ActiveRecord::Base
  belongs_to :scaffold
  belongs_to :genome

  has_many :protein_relationships, dependent: :destroy
  has_many :related_features, through: :protein_relationships

  has_many :inverse_protein_relationships, class_name: 'ProteinRelationship',
    foreign_key: :related_feature_id

  has_many :inverse_related_features, through: :inverse_protein_relationships,
    source: :feature

  # for now I am only going to call AAs "weird" if they have gaps
  # xxx this needs to be better defined with some biological background
  # xxx need to verify that the start codon makes sense
  def weird?
    self.protein_sequence[1..-2].include? '*'
  end

  def sequence
    i =  -1 + self.start
    j = -1 + self.stop
    seq =  self.scaffold.sequence[i..j]
    if strand == '-'
      seq = seq.reverse.complement
    end
    seq
  end

  # xxx real slow!
  def protein_sequence
    # create a new nucleotide sequence, translate it.
    # do NOT use 'auto' as it will sometimes mistake nucleotide for
    # amino acid
    self.sequence.downcase.chars.each_slice(3).map do |sl|
      CODON_TABLE[sl.join]
    end.join
  end

  def product
    self.info.match(/product=([^;]*);/)[1] rescue 'NA'
  end

end
