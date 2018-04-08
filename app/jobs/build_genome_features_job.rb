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

  def scaffolds
    Enumerator.new do |enum|
      genbank_data.split("\nLOCUS").each do |locus|
        enum.yield Bio::GenBank.new(locus)
      end
    end
  end

  def features
    Enumerator.new do |enum|
      scaffolds.each do |scaffold|
        scaffold.features.each do |feature|
          unless exclude_feature? feature
            attributes = parse_attributes(scaffold: scaffold, feature: feature)
          end
        end
      end
    end
  end

  def exclude_feature? feature
    (feature.feature =~ /source/) || (feature.type =~ /assembly_gap/) || (feature.qualifiers.nil?)
  end

  def parse_attributes scaffold: nil, feature: nil
    genbank_hash = feature.to_hash
    position = feature.position.match(/(\d*)\.\.(\d*)/)

    # TODO: strand, nucleotide sequence ...
    {
      start: Integer(position[1]),
      stop: Integer(position[2]),
      strain: strain,
      translation: feature['translation'].try(:first),
      feature_type: genbank_hash.feature
    }
  end

  def perform
    ActiveRecord::Base.transaction do
      genome.features.destroy_all
    end
  end

  def genbank_data
    @genbank_data ||= open(genbank_url).readlines
  end

  def genbank_url
    ftp_path = genome.ncbi_metadata['ftp_path']
    # get last path in ftp_path. this forms part of the genbank file's filename
    basename = File.basename(ftp_path)
    "#{ftp_path.gsub(/ftp:\/\//, 'https://')}/#{basename}_genomic.gbff.gz"
  end
end
