require 'rails_helper'

describe Genome do

  let(:genome) { create(:genome) }

  it 'can be created' do
    expect(genome).to_not be(nil)
  end

  it 'has an assembly id' do
    expect(genome.assembly_id).to_not be(nil)
  end

  it 'cannot be created without an assembly id' do
    genome = build(:genome, assembly_id: nil)
    expect(genome.save).to be(false)
    expect{ genome.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
