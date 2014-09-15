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
  let (:scaffold) { Scaffold.new sequence: 'GATC', genome_id: genome.id }

  it '.new' do
    expect(scaffold).not_to be(nil)
  end

  it '.save' do
    expect(scaffold.save).not_to be(nil)
  end
end
