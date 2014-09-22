require 'zlib'

namespace :seed do

  desc 'add NCBI genomes in data/'
  task :genomes do
    genomes = Dir['data/*/']

    # clear loggers b/c this is too noisy
    App::DB.loggers = []

    App::DB.transaction {

    genomes.each do |genome_dir|

      files = get_genome_files(genome_dir)
      gff, fna = files[:gff], files[:fna]

      assembly_id = File.basename(genome)

      @genome = Genome.new assembly_id: assembly_id
      @genome.update_info_from_ncbi! # triggers save
      
      puts "adding genome: #{@genome.organism}."

      # create scaffolds
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

      # create features
      # this code is highly optimized and therefore real ugly
      # but I was able to get loading time down to 5 minutes from 100
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

    }
  end
end


# return fna and gff file paths given a path to an NCBI assembly download
# directory
def get_genome_files path
  # list files in genome path and group by extension
  bf = Dir[File.join(directory, '*')].group_by { |x| x[-6..-1] }

  # XXX assumes there is only one gff and fna file per directory
  { fna: bf['fna.gz'].first, gff: bf['gff.gz'].first }
end
