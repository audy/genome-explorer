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

      @genome = Genome.create assembly_id: File.basename(genome)
      puts "adding genome: #{@genome.assembly_id}."

      Zlib::GzipReader.open(fna) do |handle|
        records = Dna.new(handle, format: :fasta)
        records.each do |record|
          @scaffold = Scaffold.create genome: @genome,
                                      sequence: record.sequence
        end
      end

      puts "- #{@genome.scaffolds.count} scaffolds."

      puts 'adding features'
      columns = %w{start stop source strand score type info scaffold_id genome_id}.map &:to_sym
      Zlib::GzipReader.open(gff) do |handle|
        # prevents procs from being stored in memory. will break hooks.
        Feature.use_after_commit_rollback = false
        App::DB.transaction {
          handle.each_slice(1000) do |chunk|

            dat = chunk.reject { |x| x[0] == '#' }.map do |x|
              parse_gff_line(x).merge(scaffold_id: @scaffold.id,
                                   genome_id: @genome.id).values_at(*columns)
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
  line = line.strip.split("\t")
  scaffold_id = line[0].to_i
  source = line[1]
  type = line[2]
  start = line[3].to_i
  stop = line[4].to_i
  score = line[5].to_f
  strand = line[6] == '+' ? 'forward' : 'reverse'
  info = line[8]

  { start: start,
    source: source,
    stop: stop,
    strand: strand,
    score: score,
    type: type,
    info: info }
end
