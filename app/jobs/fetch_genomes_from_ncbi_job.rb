class FetchGenomesFromNCBIJob

  URL_ASSEMBLY_SUMMARY = 'https://ftp.ncbi.nih.gov/genomes/refseq/bacteria/assembly_summary.txt'

  def queue_name
    'default'
  end

  def perform
    assembly_summaries do |summary|
      genome = Genome.create! ncbi_metadata: summary
      ap genome
    end
  end

  private

  # fetch assembly summaries from NCBI and yield each one in an Enumerator
  def assembly_summaries &block
    # can't use Enum because the file stream will be closed
    open(URL_ASSEMBLY_SUMMARY) do |handle|
      handle.gets # skip first line
      header = handle.gets.strip.split("\t")
      header[0] = header[0].gsub(/# /, '') # remove comment from header
      handle.each do |line|
        if line =~ /^#/
          next
        else
          row = line.strip.split("\t")
          block.yield(Hash[header.zip(row)])
        end
      end
    end
  end
end
