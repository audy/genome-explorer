require 'rails_helper'

describe Genome do

  # build a genome using data from NCBI
  before :all do
    # mycobacterium smegmatis str. MC2 155
    #  a relatively small genome
    #  any way to skip this?
    #  do I want to skip this?
    @genome = Genome.create assembly_id: 36108
    @genome.build
  end

  let(:genome) { Genome.create assembly_id: 1234 }

  it 'can be saved' do
    expect(genome.save).to_not be(false)
  end

  it 'can be created' do
    expect(genome).to_not be(nil)
  end

  it 'has an assembly id' do
    expect(genome.assembly_id).to_not be(nil)
  end

  it 'cannot be created without an assembly id' do
    genome = Genome.new assembly_id: nil
    expect(genome.save).to be(false)
    expect{ genome.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it '#destroy removes associated features and scaffolds' do
    genome_id = genome.id

    # create a genome relationship
    g2 = Genome.create assembly_id: 4567
    genome.related_genomes << g2
    related_ids = genome.related_genomes.map(&:id)
    genome.save!

    expect{genome.destroy!}.to_not raise_error

    expect(Scaffold.where(genome_id: genome_id).count).to eq(0)
    expect(Feature.where(genome_id: genome_id).count).to eq(0)
    expect(GenomeRelationship.where(genome_id: genome_id).count).to eq(0)
    expect(GenomeRelationship.where(related_genome_id: genome_id).count).to eq(0)
  end

  it '#destroy removes associated genome relationships' do
    g1 = Genome.create assembly_id: 78910
    g2 = Genome.create assembly_id: 91011
    g1.related_genomes << g2
    g1.save
    g1.destroy
    expect(g2.reload.related_genomes).to be_empty
    expect(GenomeRelationship.where(genome_id: g1.id)).to be_empty
    expect(GenomeRelationship.where(related_genome_id: g1.id)).to be_empty
  end

  it '#annotated? returns false by default' do
    expect(genome.annotated?).to be(false)
  end

  # this is a slow test which is why I'm combining multiple things into one
  # maybe I should just use `before`.
  it '#build pulls data from NCBI' do
    expect(@genome.features).to_not be_empty
    expect(@genome.scaffolds).to_not be_empty
  end

  it '#annotated? equals true after #build is called' do
    expect(@genome.annotated?).to be(true)
  end
end
