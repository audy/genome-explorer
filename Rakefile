# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :proteins do

  desc 'dump all proteins to proteins.fasta'
  task :dump => :environment do

    out = File.open('proteins.fasta', 'w')
    ActiveRecord::Base.logger.level = 1

    pbar = ProgressBar.new 'dumping', Feature.where(feature_type: 'CDS').count

    Scaffold.all.each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        seq = feature.protein_sequence
        # skip proteins w/ weird starts or stops in the middle or dont end in a
        # stop.
        pbar.inc
        out.puts ">#{feature.id}\n#{feature.protein_sequence}" unless feature.weird?
      end
    end

    pbar.finish
    out.close

  end

end

namespace :proteinstore do
  task :load do

    @store = ProteinStore.new

    puts "connected to #{@store.socket}"

    pbar = ProgressBar.new 'loading', Feature.where(feature_type: 'CDS').count

    Scaffold.all.each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        @store.add feature.protein_sequence, feature.id
      end
    end

    pbar.finish
  end

  task :query do

    @store = ProteinStore.new

    Scaffold.all.each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        p @store.query feature.protein_sequence
      end
    end

  end
end

namespace :similarities do

  desc 'load similarities from blast-like tabular output'
  task :load do
    # create new Protein-Protein relationships
  end

end
