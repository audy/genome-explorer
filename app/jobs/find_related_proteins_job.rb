class FindRelatedProteinsJob

  def initialize
    @method = 'usearch'
    @ncpu = 24
    @identity = '0.2'
  end

  # dump proteins to fasta file
  def perform
    DumpProteinsToFileJob.new('proteins.fasta').perform
    run_usearch
    build_relationships_from_blast_output
  end


  def run_usearch
    system %Q{usearch \
        -usearch_local proteins.fasta \
        -db proteins.fasta \
        -id #{@identity} \
        -blast6out proteins.blast6.tab \
        -threads #{@ncpu} \
        -maxaccepts 128 \
        -maxrejects 256}
  end

  def build_relationships_from_blast_output
    ProteinRelationship.transaction do
      ProteinRelationship.delete_all
      File.open('proteins.blast6.tab') do |handle|
        pbar = ProgressBar.new 'loading', File.size(handle.path)
        columns = [ :feature_id, :related_feature_id ]
        read_blast_file(handle).each_slice(10_000) do |values|
          pbar.set handle.pos
          ProteinRelationship.import columns, values, validate: false
        end
        pbar.finish
      end
    end
  end

  def parse_blast_line line
    fields = line.strip.split("\t")
    # query, subject
    [ fields[0],
      fields[1] ]
  end

  def read_blast_file handle
    Enumerator.new do |enum|
      handle.each do |line|
        enum.yield parse_blast_line(line)
      end
    end
  end

end
