class BuildGenomeFeaturesJob
  def queue
    'default'
  end

  def initialize genome
    @genome = genome
  end

  def genome
    @genome
  end

  def perform
  end

  def genbank_url
    ftp_path = genome.ncbi_metadata['ftp_path']
    # get last path in ftp_path. this forms part of the genbank file's filename
    basename = File.basenam(ftp_path)

    http_path = "#{ftp_path.gsub(/ftp/, 'https')}/#{basename}_genomic.gbff.gz"
  end
end
