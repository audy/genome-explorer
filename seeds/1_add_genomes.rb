require 'zlib'

namespace :seed do

  desc 'add NCBI genomes in data/'
  task :genomes do
    genomes = Dir['data/*/']

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

      # todo: get taxid from assembly id or from GFF file
      Zlib::GzipReader.open(gff) do |handle|
        App::DB.transaction do
          handle.each do |line|
            next if line[0] == '#'
            gff_data = parse_gff_line(line).merge(scaffold: @scaffold,
                                                  genome: @genome)
            feature = Feature.create(gff_data)
          end
        end
      end

      puts "- #{@genome.features.count} features."

    end
  end
end

def parse_gff_line(line)
  line = line.strip.split("\t")
  scaffold_id = line[0].to_i
  source = line[1]
  type = line[2].to_sym
  start = line[3].to_i
  stop = line[4].to_i
  score = line[5].to_f
  strand = line[6] == '+' ? :forward : :reverse 
  info = Hash[line[8].split(';').map { |x| k, v = x.split('=') }]

  { start: start,
    source: source,
    stop: stop,
    strand: strand,
    score: score,
    type: type,
    info: info }
end
