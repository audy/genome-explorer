require 'rails_helper'

describe Feature do

  let(:genome) { Genome.create }
  let(:scaffold) { Scaffold.create sequence: 'ATGGATCAATGA'  }
  let(:feature) { Feature.create genome: genome,
                    scaffold: scaffold,
                    feature_type: 'CDS',
                    start: 1,
                    stop: 12
            }

  it 'can be created' do
    expect(feature).to_not be(nil)
  end

  it 'has a scaffold' do
    expect(feature.scaffold).to_not be(nil)
    expect(feature.scaffold).to eq(scaffold)
  end

  it 'has a scaffold with a sequence' do
    expect(feature.scaffold.sequence).to_not be(nil)
  end

  it 'belongs to a genome' do
    expect(feature.genome).to eq(genome)
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

  it 'updates genome attribute if it is added to genome.features' do
    f = Feature.create
    g = Genome.create
    g.features << f
    g.save
    expect(f.genome.id).to eq(genome.id)
  end

end
