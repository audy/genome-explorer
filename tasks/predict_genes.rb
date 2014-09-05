require 'tempfile'


def parse_gff_line(line)
  line = line.strip.split("\t")
  type = line[2] == 'CDS' ? :CDS : nil
  start = line[3].to_i
  stop = line[4].to_i
  score = line[5].to_f
  strand = line[6] == '+' ? :forward : :reverse 

  Feature.new(start: start,
              stop: stop,
              strand: strand,
              score: score)
end

def predict_features(fasta_file)
  # prodigal -f gff -i data/dorei728.fasta
  `prodigal -f gff -i #{fasta_file}`.split("\n").map do |line|
    next if line =~ /^#/
    parse_gff_line(line)
  end.reject { |x| x.nil? }
end

namespace :genomes do

  task :predict_genes do
    Scaffold.each do |scaffold|
      predict_features(scaffold.nucleotides_file).each do |feature|
        feature.scaffold = scaffold
        feature.save
      end
    end
  end

end
