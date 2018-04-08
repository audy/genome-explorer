# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# seed with a few similar, small genomes
# E.g. Mycoplasma

[
  183078, # B. dorei DSM 17855
  202521, # B. dorei 105
  202531, # B. dorei 439
  33928,  # B. vulgatus ATCC 8482
  472768, # B. vulgatus CL09T03C04
  224378, # B. vulgatus PC510
  31428,  # B. fragilis YCH46
].each do |assembly_id|
  puts "downloading genome assembly: #{assembly_id}"
  genome = Genome.create assembly_id: assembly_id
  puts "building..."
  genome.build
  puts "new genome: #{genome}"
end
