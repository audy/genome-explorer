require 'test_helper'

class GenomeTest < ActiveSupport::TestCase

  test 'should not save without an assembly id' do
    genome = Genome.new
    assert_not genome.save
  end

  test 'should not save if a duplicate assembly id exists' do
    genome = Genome.create assembly_id: 1234
    genome2 = Genome.new assembly_id: 1234

    assert_not genome2.save
  end

end
