require 'spec_helper'

describe 'models' do

  let (:genome) { Genome.new assembly_id: 1 }
  let (:scaffold) { Scaffold.new sequence: 'GATCGATCGATCGATC', genome_id:
                    genome.id }
  let (:feature) { Feature.new start: 1, stop: 10, source: 'test-source', score:
                   0.9, info: 'test-info', type: 'test-type' }

describe Genome do

  it '.new' do
    expect(genome).not_to be(nil)
  end

  it '.save' do
    expect(genome.save).to_not be(nil)
  end

  it '.assembly_id' do
    expect(genome.assembly_id).to_not be(nil)
  end

  it '.scaffolds <<' do
    scaffold.save
    genome.scaffolds << scaffold
    genome.save
    expect(genome.scaffolds[0]).to be(scaffold)
  end

  it '.scaffolds (added by scaffold.genome =)' do
    genome.save
    scaffold.genome = genome
    scaffold.save
    expect(genome.scaffolds[0].id).to eq(scaffold.id)
  end

end

describe Scaffold do

  it '.new' do
    expect(scaffold).not_to be(nil)
  end

  it '.save' do
    expect(scaffold.save).not_to be(nil)
  end

  it '.genome .genome=' do
    genome.save
    scaffold.genome = genome
    expect(scaffold.save).not_to eq(nil)
    expect(scaffold.genome).to be(genome)
  end

  it '.features <<' do
    scaffold.save
    genome.scaffolds << scaffold
    genome.save
    expect(genome.scaffolds[0]).to be(scaffold)
  end

  it '.features = (added by features)' do
    scaffold.save
    feature.scaffold = scaffold
    feature.save
    expect(scaffold.features[0]).to eq(feature)
  end
end

describe Feature do

  it '.new' do
    expect(feature).to_not eq(nil)
  end

  it '.save' do
    expect(feature.save).to_not eq(nil)
  end

  it '.start .stop' do
    expect(feature.start).to eq(1)
    expect(feature.start).to be_a(Integer)

    expect(feature.stop).to eq(10)
    expect(feature.stop).to be_a(Integer)
  end

  it '.score' do
    expect(feature.score).to eq(0.9)
    expect(feature.score).to be_a(Float)
  end

  it '.type .source .info' do
    expect(feature.type).to eq('test-type')
    expect(feature.type).to be_a(String)

    expect(feature.source).to eq('test-source')
    expect(feature.source).to be_a(String)

    expect(feature.info).to eq('test-info')
    expect(feature.info).to be_a(String)
  end

  it '.scaffold .scaffold=' do
    scaffold.save
    feature.scaffold = scaffold
    expect(feature.save).not_to eq(nil)
    expect(feature.scaffold).to be(scaffold)
  end

end

end
