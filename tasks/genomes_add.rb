namespace :genomes do

  desc 'add NCBI genomes in data/'
  task :add do
    files = Dir['data/*'].group_by { |x| File.basename(x).split('.')[0] }

    files.each_pair do |_, bf|
      bf = bf.group_by { |x| File.extname(x) }

      # there can only be one
      gff = bf['.gff'].first
      fna = bf['.fna'].first

      File.open(fna) do |handle|
        records = Dna.new(handle)
        records.each do |record|
          @genome = Genome.first_or_create( name: get_genome(record.name) )
          @scaffold = Scaffold.create genome: @genome,
                                      sequence: record.sequence
        end
      end

      puts @genome.name

      File.open(gff) do |handle|
        handle.each do |line|
          next if line[0] == '#'
          gff = parse_gff_line(line)
          gff[:scaffold] = @scaffold
          feature = Feature.create(gff)
          print '.'
        end
      end
    end
  end
end

def get_genome(s)
  s.split[1..4].join(' ')
end

def parse_gff_line(line)
  line = line.strip.split("\t")
  scaffold_id = line[0].to_i
  type = line[2].to_sym
  start = line[3].to_i
  stop = line[4].to_i
  score = line[5].to_f
  strand = line[6] == '+' ? :forward : :reverse 
  info = Hash[line[8].split(';').map { |x| k, v = x.split('=') }]

  { start: start,
    stop: stop,
    strand: strand,
    score: score,
    type: type,
    info: info }
end
