namespace :genomes do

  desc 'add genomes in data/*.fasta do genomes database'
  task :add do
    Dir['data/*.fasta'].each do |genome_file|
      genome = Genome.create! file_path: genome_file


      File.open(genome_file) do |handle|
        records = Dna.new(handle)
        records.each do |record|
          scaffold = Scaffold.new sequence: record.sequence, genome: genome
          scaffold.save
        end
      end

      puts "Added genome #{genome} with #{genome.scaffolds.size} scaffolds"

    end
  end

end
