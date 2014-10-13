# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :compute do

  file 'proteins.fasta' => :dump_proteins

  desc 'dump all proteins to proteins.fasta'
  task :dump_proteins => :environment do
    DumpProteinsToFileJob.new('proteins.fasta').perform
  end

  desc 'compute related proteins (via USEARCH)'
  task :related_proteins => [:environment, 'proteins.fasta'] do
    FindRelatedProteinsJob.new.perform
  end

  desc 'compute related genomes from related proteins'
  task :related_genomes => [ :environment, :related_proteins ] do
    FindRelatedGenomesJob.new.perform
  end
end
