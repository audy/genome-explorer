require 'rails_helper'

describe DumpProteinsToFileJob do

  # todo use tempfile
  let (:job) { DumpProteinsToFileJob.new('test.fasta') }

  it 'can be created' do
    expect(job).not_to be(nil)
  end

  it 'dumps proteins to a file' do
    feature = create(:feature)
    # job returns the number of sequences dumped
    expect(job.perform).to eq(1)
    expect(File.exists?(job.filename)).to_not be(false)
  end

end
