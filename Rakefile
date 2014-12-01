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
