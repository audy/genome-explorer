require 'rails_helper'

describe Feature do
  let(:genome) { Genome.create }
  let(:feature) { Feature.create genome: genome,
                    feature_type: 'CDS',
                    start: 1,
                    stop: 12
            }

  it 'can be created' do
    expect(feature).to_not be(nil)
  end

  it 'belongs to a genome' do
    expect(feature.genome).to eq(genome)
  end
end
