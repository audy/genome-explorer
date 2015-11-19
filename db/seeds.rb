puts 'looking for genomes'


Dir['genomes/*.fasta'].each_with_index do |fna, i|

  gff = File.join(File.dirname(fna), File.basename(fna, '.fasta') + '.gff')

  genome = Genome.create! assembly_id: i, fna_file: File.expand_path(fna), gff_file: File.expand_path(gff)
  puts "building... #{genome.assembly_id}"
  genome.build
  puts "new genome: #{genome.assembly_id}"
end

# This will only create the genomes It will not download their annotations or
# build any graphs. This part should be part of the seed as I want this to be
# able to generate a minimum working web app.

# construct social graph
UpdateGenomeRelationshipsPipelineJob.new.perform
