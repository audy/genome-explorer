require 'spec_helper'


describe Genome do

  let(:genome) { Genome.new assembly_id: 1 }

  it '.new' do
    expect(genome).not_to be(nil)
  end

  it '.save' do
    expect(genome.save).to_not be(nil)
  end

  it '.assembly_id' do
    expect(genome.assembly_id).to_not be(nil)
  end

end

describe Scaffold do

  let (:genome) { Genome.new assembly_id: 1 }
  let (:scaffold) { Scaffold.new sequence: 'GATCGATCGATCGATC', genome_id:
                    genome.id }

  it '.new' do
    expect(scaffold).not_to be(nil)
  end

  it '.save' do
    expect(scaffold.save).not_to be(nil)
  end
end

describe Feature do

  let (:genome) { Genome.new assembly_id: 1 }
  let (:scaffold) { Scaffold.new sequence: 'GATCGATCGATCGATC', genome_id:
                    genome.id }
  let (:feature) { Feature.new start: 1, stop: 10, source: 'test-source', score:
                   0.9, info: 'test info', type: 'test-type' }

  it '.new' do
    expect(feature).to_not be(nil)
  end

  it '.save' do
    expect(feature.save).to_not be(nil)
  end

end
