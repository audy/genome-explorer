require 'rails_helper'

describe Genome, requires_bionode: true do
  # build a genome using data from NCBI
  before :all do
    # mycobacterium smegmatis str. MC2 155
    #  a relatively small genome
    #  any way to skip this?
    #  do I want to skip this?
    @genome = Genome.create assembly_id: 36108
    @genome.build fna_path: 'spec/data/31608/GCA_000010105.1_ASM1010v1_genomic.fna.gz',
                  gff_path: 'spec/data/31608/GCA_000010105.1_ASM1010v1_genomic.gff.gz'
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
    expect { genome.destroy! }.to_not raise_error
    expect(Scaffold.where(genome_id: genome_id).count).to eq(0)
    expect(Feature.where(genome_id: genome_id).count).to eq(0)
  end
end
