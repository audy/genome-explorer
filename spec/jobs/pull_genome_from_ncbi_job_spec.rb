require 'rails_helper'

describe PullGenomeFromNCBIJob do

  # how to test without being really slow or annoying to NCBI?
  let(:pull_genome_from_ncbi_job) { PullGenomeFromNCBIJob.new 1234 }

  it 'can be created'

end
