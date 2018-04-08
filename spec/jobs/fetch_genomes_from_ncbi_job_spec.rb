require 'spec_helper'

describe FetchGenomesFromNCBIJob, focus: true do

  # use a local, truncated assembly summaries file so 50k genomes are not
  # downloaded and created
  FetchGenomesFromNCBIJob::URL_ASSEMBLY_SUMMARY = 'spec/data/assembly_summary.20.txt'

  it 'fetches genomes from NCBI' do
    expect { FetchGenomesFromNCBIJob.new.perform }.to_not raise_error
  end
end
