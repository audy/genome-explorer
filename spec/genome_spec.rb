require 'spec_helper'

describe Genome do
  let (:genome) { Genome.new assembly_id: 121751 }

  it '.fetch_assembly_info_from_ncbi!' do
    genome.fetch_assembly_info_from_ncbi!
    expect(genome.assembly_data).to_not be(nil)
    expect(genome.assembly_data).to be_a(String)
  end

end
