require 'spec_helper'

#
# these tests are for Graphs which is really a set of ways of viewing the
# GenomeRelationships table.
#

describe Graphs do

  before(:context) do
    # setup some genomes and features and feature relationships

    g1 = Genome.create! assembly_id: 1234
    g2 = Genome.create! assembly_id: 4567

    5.times { Feature.create! genome: g1, feature_type: 'CDS' }
    5.times { Feature.create! genome: g2, feature_type: 'CDS' }

    g1.features.each do |f_i|
      g2.features.each do |f_j|
        f_i.related_features << f_j
        f_i.save!
      end
    end

    # build genome relationships graph
    FindRelatedGenomesJob.new.perform
  end

  let(:graph) { Graphs::Builder.new.build(Genome.first)  }

  it 'can be created' do 
    expect{ graph }.to_not raise_error
  end

  it 'can be used to build a genome-genome graph' do
    expect(graph).to_not be_nil
  end

  it 'has nodes' do
    expect(graph[:nodes]).to_not be_nil
    expect(graph[:nodes].size).to_not eq(0)
  end

end
