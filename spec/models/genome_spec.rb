require 'rails_helper'

describe Genome do

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

    scaffold_id = Scaffold.create!(genome: genome).id
    feature_id = Feature.create!(genome: genome).id
    g2 = Genome.create assembly_id: 4567

    genome.related_genomes << g2
    related_ids = genome.related_genomes.map(&:id)

    genome.save!

    expect{genome.destroy!}.to_not raise_error

    expect(Scaffold.first(scaffold_id)).to be_empty
    expect(Feature.first(feature_id)).to be_empty
    expect(GenomeRelationship.all).to be_empty
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

end
