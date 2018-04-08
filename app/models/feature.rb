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
  belongs_to :genome

  # for now I am only going to call AAs "weird" if they have gaps
  # xxx this needs to be better defined with some biological background
  # xxx need to verify that the start codon makes sense
  def weird?
    self.protein_sequence[1..-2].include? '*'
  end

  def protein_coding?
    self.feature_type == 'CDS'
  end

  # Used to get only protein-coding genes (useful b/c CDS definition may change
  # or be expanded)
  # TODO: move to scope
  def self.proteins
    self.where(feature_type: 'CDS')
  end

  # aka nucleotide sequence
  def sequence
    sequence_from_scaffold
  end

  def protein_sequence
    protein_sequence_from_scaffold
  end

  def product
    info.match(/product=([^;]*);/)[1] rescue 'NA'
  end
end
