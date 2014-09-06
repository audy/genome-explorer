namespace :genomes do
  desc 'add NCBI genomes in data/'
  task :add do
    Dir['data/*'].shuffle.each do |genome_directory|
      glob = File.join(genome_directory, '*')

      puts "adding #{genome_directory}"
      @genome = Genome.first_or_create file_path: genome_directory
      @annotation = Annotation.new source: 'ncbi', genome: @genome

      grouped = Dir[glob].group_by { |x| File.basename(x).split('.')[0] }
      grouped.each_pair do |scaffold, files|
        fs = files.group_by { |x| File.extname(x) }

        scaffold = fs['.fna'].first
        annotation = fs['.gff'].first

        File.open(scaffold) do |handle|
          records = Dna.new(handle)
          @scaffold = Scaffold.create sequence: records.to_a.first.sequence,
            genome: @genome,
            annotations: [ @annotation ]
        end

        File.open(annotation) do |handle|
          handle.each do |line|
            if line[0] != '#'
              feature = parse_gff_line(line)
              feature[:annotation] = @annotation
              f = Feature.new(feature)
              begin
                f.save
              rescue
                puts "weird feature: #{f.inspect}"
              end
            end
          end
        end
        print "\n"

      end

      @annotation.save

    end
  end
end

def parse_gff_line(line)
  line = line.strip.split("\t")
  scaffold_id = line[0].to_i
  type = line[2].to_sym
  start = line[3].to_i
  stop = line[4].to_i
  score = line[5].to_f
  strand = line[6] == '+' ? :forward : :reverse 

  { start: start,
    stop: stop,
    strand: strand,
    score: score,
    type: type }
end
