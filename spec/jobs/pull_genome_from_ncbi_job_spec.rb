require 'rails_helper'

describe PullGenomeFromNCBIJob do

  # Mycoplasma genitalium G37 (smallest bacterial genome)

  it '#perform takes a genome ID and builds a genome' do
    genome = Genome.create! assembly_id: 203758 
    expect{PullGenomeFromNCBIJob.new(genome.id).perform}.not_to raise_error
    expect(genome.features.count).not_to eq(0)
    expect(genome.scaffolds.count).not_to eq(0)
  end

end
