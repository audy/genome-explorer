require 'rails_helper'

describe DumpProteinsToFileJob do

  let(:genome) { Genome.create! assembly_id: 2345 }
  let(:scaffold) { Scaffold.create! sequence: 'ATGGATCAATGA', genome_id: genome.id  }
  let(:feature) { Feature.create! genome: genome,
                    scaffold: scaffold,
                    feature_type: 'CDS',
                    start: 1,
                    stop: 12
            }

  let(:records) {
    File.open(job.filename) do |handle|
      Dna.new(handle, :format => :fasta).to_a
    end
  }
  
  # todo use tempfile
  let (:job) { DumpProteinsToFileJob.new('test.fasta') }

  it 'can be created' do
    expect(job).not_to be(nil)
  end

  it 'performs' do
    # these need to be instantiated manually
    genome; feature; scaffold
    # job returns the number of sequences dumped
    expect(job.perform).to eq(1)
  end

  it 'creates a file' do
    expect(File.exists?(job.filename)).to_not be(false)
  end

  it 'creates a file with proteins that match' do
    expect(records.first.sequence).to eq(feature.protein_sequence)
  end

  it '#perform accepts a list of genomes (ids) to get proteins from' do
    g = genome.dup
    g.assembly_id = g.assembly_id + 1
    g.save

    dumped = DumpProteinsToFileJob.new('test.fasta', Genome.last.id)
    expect(records.first.sequence).to eq(feature.protein_sequence)
  end

end
