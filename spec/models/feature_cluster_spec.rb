require 'rails_helper'

RSpec.describe FeatureCluster, :type => :model do

  it 'can be created' do
    expect{FeatureCluster.create}.not_to raise_error
  end

  it 'has many features' do
    c = FeatureCluster.create!
    f = Feature.create!

    f.update feature_cluster: c

    expect(c.features.first).to eq(f)
    expect(f.feature_cluster).to eq(c)
  end

end
