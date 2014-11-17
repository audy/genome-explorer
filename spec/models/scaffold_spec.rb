require 'rails_helper'

describe Scaffold do

  let(:genome) { Genome.create }
  let(:scaffold) { Scaffold.create sequence: 'ATGGATCAATGA', genome: genome  }
  let(:feature) { Feature.create genome: genome,
                    scaffold: scaffold,
                    feature_type: 'CDS',
                    start: 1,
                    stop: 12
            }

  it 'can be created' do
    expect(scaffold).not_to eq(nil)
  end

  it 'can have features' do
    # xxx trying to do this in the factory results in an infinite loop :\
    feature = Feature.create scaffold: scaffold
    expect(scaffold.features.first).to eq(feature)
  end

  it 'has a genome' do
    expect(scaffold.genome).to_not eq(nil)
  end

end
