namespace :genomes do

  desc 'add genomes in data/*.fasta do genomes database'
  task :add do
    Dir['data/*.fasta'].each do |scaffold_file|
      genome = Genome.new
      scaffold = Scaffold.new nucleotides_file: scaffold_file, genome: genome

      if scaffold.save and genome.save
        puts "added new genome #{genome.id} with scaffold #{File.basename(scaffold_file)}"
      end
    end
  end

end
