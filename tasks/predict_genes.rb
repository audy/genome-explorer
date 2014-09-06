require 'tempfile'

def predict_features(genome)
  tmp_file = Tempfile.new('scaffold')

  genome.scaffolds.each do |scaffold|
    tmp_file.puts(">#{scaffold.id}\n#{scaffold.wrap(80)}")
  end

  tmp_file.close

  results = `prodigal -f gff -i #{tmp_file.path}`

  tmp_file.unlink

  results.split("\n").map do |line|
    next if line[0] == '#'
    parse_gff_line(line)
  end.reject { |x| x.nil? }
end

namespace :genomes do

  task :predict_genes do
    Genome.each do |genome|
      features = predict_features(genome)
      puts "found #{features.size} features"
      features.each { |f|
        p f
        f.save
      }
    end
  end

end
