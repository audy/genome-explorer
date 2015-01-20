
# 1. run usearch
# 2. parse blast-6-tab output
# 3. Create new entries in the feature relationships graph

class FindRelatedProteinsJob

  def initialize kwargs = {}

    defaults = {
      method: 'usearch',
      ncpu: 24,
      identity: '0.1',
      maxaccepts: 256,
      maxrejects: 512,
      output: 'proteins.blast6.tab',
      input: 'proteins.fasta',
      database: 'proteins.fasta'
    }

    opts = defaults.update(kwargs)

    @method     = opts[:method]
    @ncpu       = opts[:ncpu]
    @identity   = opts[:identity]
    @maxaccepts = opts[:maxaccepts]
    @maxrejects = opts[:maxrejects]
    @input      = opts[:input]
    @output     = opts[:output]
    @database   = opts[:database]

  end

  # dump proteins to fasta file
  def perform
    run_usearch
    # XXX should this transaction be used here? It should be up to the calling
    # statement whether or not to use a transaction. I'm going to leave it here
    # because I can't think of a reason why it would cause something unexpected
    # to happen.
    ProteinRelationship.transaction {
      build_relationships_from_blast_output
    }
  end

  def run_usearch
    # xxx make usearch a configuration item
    system %Q{#{@method}\
        -usearch_local #{@input} \
        -db #{@database} \
        -id #{@identity} \
        -blast6out #{@output} \
        -threads #{@ncpu} \
        -maxaccepts #{@maxaccepts} \
        -maxrejects #{@maxrejects}}
  end

  def build_relationships_from_blast_output
    # todo allow for multiple types of proteinrelationships from different
    # sources.
    # todo allow for filtering criteria using `filtration_lambda` (forgive me)
    # which is a lambda that will result in hits being filtered out if it
    # evaluates to false
    File.open(@output) do |handle|
      pbar = ProgressBar.new 'loading', File.size(handle.path)
      columns = [ :feature_id, :related_feature_id, :identity ]
      read_blast_file(handle).each_slice(10_000) do |values|
        pbar.set handle.pos
        ProteinRelationship.import columns, values, validate: false
      end
      pbar.finish
    end
  end

  def parse_blast_line line
    fields = line.strip.split("\t")
    # query, subject
    [ fields[0], # query id
      fields[1], # subject id
      (100 * Float(fields[2])).to_i # percent identity, rounded
    ]
  end

  def read_blast_file handle
    Enumerator.new do |enum|
      handle.each do |line|
        enum.yield parse_blast_line(line)
      end
    end
  end

  def queue_name
    'big'
  end

end
