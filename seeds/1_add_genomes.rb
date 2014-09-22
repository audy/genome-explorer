require 'zlib'

namespace :seed do

  desc 'add NCBI genomes in data/'
  task :genomes do
    genomes = Dir['data/*/']

    # clear loggers b/c this is too noisy
    App::DB.loggers = []

    genomes.each do |genome|

      # list files in genome directory and group by extension
      bf = Dir[File.join(genome, '*')].group_by { |x| x[-6..-1] }

      # XXX assumes there is only one gff and fna file per directory
      gff = bf['gff.gz'].first
      fna = bf['fna.gz'].first

      # parse taxonomy from first line in fasta file
      accession = Zlib::GzipReader.open(fna).gets.split[0][1..-1]

      dat = JSON.parse(`bionode-ncbi search nucleotide #{accession}`)
      organism = dat['organism']

      @genome = Genome.create assembly_id: File.basename(genome),
                              organism: organism

      puts "adding genome: #{@genome}."

      Zlib::GzipReader.open(fna) do |handle|
        records = Dna.new(handle, format: :fasta)
        records.each do |record|
          @scaffold = Scaffold.create genome: @genome,
                                      sequence: record.sequence,
                                      name: record.name.split.first
        end
      end

      puts "- #{@genome.scaffolds.count} scaffolds."

      # lookup scaffold by name, memoize in a hash to speed things up
      scaffolds = Hash.new { |h,k| h[k] = Scaffold.first(name: k) }

      puts 'adding features'
      columns = %w{start stop source strand score type info scaffold_id genome_id}.map &:to_sym
      Zlib::GzipReader.open(gff) do |handle|
        # prevents procs from being stored in memory. will break hooks.
        Feature.use_after_commit_rollback = false
        App::DB.transaction {
          handle.each_slice(1000) do |chunk|

            dat = chunk.reject { |x| x[0] == '#' }.map do |x|
              dat = parse_gff_line(x)
              dat[:scaffold_id] = scaffolds[dat.delete(:scaffold_name)].id
              dat[:genome_id] = @genome.id
              dat.values_at(*columns)
            end

            App::DB[:features].import(columns, dat)

          end
        }
      end

      @genome.save # force updating of counter cache

      puts "- #{@genome.feature_count} features."

    end
  end
end

def parse_gff_line(line)

  fields = line.strip.split("\t")

  scaffold_name = fields[0]
  source        = fields[1]
  type          = fields[2]
  start         = Integer fields[3] rescue nil
  stop          = Integer fields[4] rescue nil
  score         = Float fields[5] rescue nil
  strand        = fields[6]
  frame         = Integer fields[7] rescue nil
  info          = fields[8]

  { scaffold_name: scaffold_name,
    start: start,
    source: source,
    stop: stop,
    strand: strand,
    score: score,
    type: type,
    info: info }

end
