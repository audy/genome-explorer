require 'set'

# 1. run usearch
# 2. parse blast-6-tab output
# 3. Add entries in blast-6-tab output to FeatureRelationship table
#     - doesn't skip existing relationships

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
    
    # keep a list of existing protein relationships and don't re-import them
    # can't rely on ActiveRecord to do this because we're using `import`.
    puts 'generating list of existing protein relationships'
    existing = ProteinRelationship.find_each.map { |x| [x.feature_id, x.related_feature_id ]}
    existing = existing.to_set
    
    puts "found #{existing.size} existing protein relationships"
    
    total_imported = 0
    
    File.open(@output) do |handle|
      pbar = ProgressBar.new 'loading', File.size(handle.path)
      columns = [ :feature_id, :related_feature_id, :identity ]
      read_blast_file(handle).each_slice(10_000) do |values|
        pbar.set handle.pos
        # (this part should be working now)
        values.reject! { |v| existing.include? v[0..1] }
        total_imported += values.size
        ProteinRelationship.import columns, values, validate: false
      end
      pbar.finish
    end
    
    puts "imported #{total_imported} new protein relationships"
  end

  def parse_blast_line line
    fields = line.strip.split("\t")
    # query, subject
    [ Integer(fields[0]), # query id
      Integer(fields[1]), # subject id
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
