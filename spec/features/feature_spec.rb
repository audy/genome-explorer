require 'rails_helper'

describe 'feature page', type: :feature do
 
  let (:genome) { Genome.create }
  let (:feature) { Feature.create genome: genome }

  it 'can be created' do
   expect(feature).to_not be(nil)
  end

  it 'belongs to a genome' do
    expect(feature.genome).to eq(genome)
  end

  it 'has a feature page' do
    genome = feature.genome
    expect(genome).to_not be(nil)
    visit "genomes/#{genome.id}/features/#{feature.id}"
  end

end
