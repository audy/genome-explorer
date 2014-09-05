describe Scaffold do
  let (:genome) { Genome.new }
  let (:scaffold) { Scaffold.new genome: genome}

  it 'can be created' do
    scaffold.should_not be_nil
  end

  it 'can be saved' do
    scaffold.save.should_not be_false
  end

  it 'belongs to a genome' do
    scaffold.genome.should_not be_nil
  end
end
