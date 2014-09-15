require 'spec_helper'

describe Genome do

  let(:genome) { Genome.new assembly_id: 1 }

  it '.new' do
    expect(genome).not_to be(nil)
  end

  it '.save' do
    expect(genome.save).to_not be_nil
  end

end
