require 'rails_helper'

describe Genome, requires_bionode: true do

  let(:genome) { Genome.create }

  it 'can be saved' do
    expect(genome.save).to_not be(false)
  end

  it 'can be created' do
    expect(genome).to_not be(nil)
  end

  it '#destroy removes associated features and scaffolds' do
    genome_id = genome.id
    expect { genome.destroy! }.to_not raise_error
    expect(Scaffold.where(genome_id: genome_id).count).to eq(0)
    expect(Feature.where(genome_id: genome_id).count).to eq(0)
  end
end
