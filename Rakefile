# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'clean up dead records and relations'
task :clean_db => :environment do
  ActiveRecord::Base.transaction do

    # slow!!! and I don't think caching helps much
    ActiveRecord::Base.cache {
        pbar = ProgressBar.new 'feature relationships', ProteinRelationship.count
        ProteinRelationship.find_each do |relation|
          if relation.feature.nil? or relation.related_feature.nil? or relation.feature.genome.nil? or relation.related_feature.genome.nil?
            relation.delete
          end
          pbar.inc
        end
        pbar.finish

      pbar = ProgressBar.new 'features', Feature.count
      Feature.find_each do |feature|
        feature.delete if feature.genome.nil?
        # this happens automatically now
        # feature.scaffold.delete if feature.genome.nil?
        pbar.inc
      end
      pbar.finish

      pbar = ProgressBar.new 'genome relationships', GenomeRelationship.count
      GenomeRelationship.find_each do |relation|
        if relation.genome.nil? or relation.related_genome.nil?
          relation.delete
        end
        pbar.inc
      end
      pbar.finish

      pbar = ProgressBar.new 'scaffolds', Scaffold.count
      Scaffold.find_each do |scaffold|
        scaffold.delete if scaffold.genome.nil?
        pbar.inc
      end
      pbar.finish

    } # cache

  end
end

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
