describe Feature do
  let (:genome) { Genome.new }
  let (:scaffold) { Scaffold.new genome: genome}
  let (:feature) { Feature.new scaffold: scaffold, type: :CDS }

  it 'can be saved' do
    feature.should_not be_nil
  end

  it 'can be saved' do
  end

  it 'has a type' do
    feature.type.should_not be_nil
  end
end
