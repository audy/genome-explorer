require 'rails_helper'

describe Feature do

  let(:feature) { create(:feature) }

  it 'can be created' do
    expect(feature).to_not be(nil)
  end

  it 'has a scaffold' do
    expect(feature.scaffold).to_not be(nil)
  end

  it 'has a (nucleotide) sequence (from scaffold)' do
    expect(feature.sequence).to_not be(nil)
  end

  it 'has a translated amino acid sequence (from scaffold)' do
    expect(feature.protein_sequence).to eq('MDQ*')
    expect(feature.protein_sequence.size).to eq(feature.scaffold.sequence.size/3)
  end

  it 'translated AA sequence begins with a methionine if the feature isnt "weird"' do
    expect(feature.protein_sequence[0]).to eq('M')
    expect(feature.weird?).to eq(false)
  end

  it 'translated AA sequence ends with a stop codon represented by an asterisk' do
    expect(feature.protein_sequence.last).to eq('*')
  end

  it 'has a feature_type' do
    expect(feature.feature_type).to_not eq(nil)
    expect(feature.feature_type).to eq('CDS')
  end

  it '#protein_sequence correctly handles start codons'

  it '#protein_sequence correctly translates (bacterial) mRNAs'

end
