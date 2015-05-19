# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :enqeue do

  file 'proteins.fasta' => :dump_proteins

  desc 'dump all proteins to proteins.fasta'
  task :dump_proteins => :environment do
    DumpProteinsToFileJob.new('proteins.fasta').delay.perform
  end

  desc 'compute related proteins (via USEARCH)'
  task :related_proteins => [ :environment ] do
    FindRelatedProteinsJob.new.delay.perform
  end

  desc 'compute related genomes from related proteins'
  task :related_genomes => [ :environment ] do
    FindRelatedGenomesJob.new.delay.perform
  end

  desc 'find related genomes pipeline'
  task :related_genomes_pipeline => [ :environment ] do
    UpdateGenomeRelationshipsPipelineJob.new.delay.perform
  end
end

namespace :version do

  desc 'print current version number to STDOUT'
  task :show do
    puts Omgenomes::Version::STRING
  end

  desc 'increment version number'
  task :bump do
  end
end

#
# [ genome_id: {
#     features: { feature_id: {
#           start: i, stop: j,
#           related_features { related_id: { similarity: }, ... }
#     }, ...
#  }, ... // serialized
# ]
#

desc 'dump DB to serialized json for machine learning'
task :to_json do

  require 'json'

  pbar = ProgressBar.new 'dumping', Feature.proteins.count

  Genome.find_each do |genome|

    gh = Hash.new
    gh[:id] = genome.id
    gh[:organism] = genome.organism
    gh[:assembly_id] = genome.assembly_id

    gh[:features] =
      genome.features.proteins.find_each.map do |feature|
        pbar.inc
        {
          id: feature.id,
          start: feature.start,
          stop: feature.stop,
          strand: feature.strand,
          related: feature.protein_relationships.find_each.map do |rf|
            {
              id: rf.related_feature_id,
              similarity: 0
            }
          end
        }
      end

    puts gh.to_json
  end

  pbar.finish
end

namespace :dump do

  desc 'dump genomes db to CSV'
  task :genomes_table => :environment do
    puts 'id,assembly_id,organism'
    Genome.find_each do |g|
      puts [g.id, g.assembly_id, g.organism].join(',')
    end
  end

  desc 'dump features to CSV'
  task :features_table => :environment do
    puts 'id,genome_id,product,type,start,stop'
    Feature.find_each do |f|
      puts [f.id, f.genome_id, f.product, f.feature_type, f.start, f.stop].join(',')
    end
  end

  desc 'dump proteins to FASTA'
  task :proteins => :environment do
    DumpProteinsToFileJob.new('/dev/stdout').perform
  end

end
