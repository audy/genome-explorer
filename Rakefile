# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :dump do

  desc 'dump all proteins to proteins.fasta'
  task :proteins => :environment do

    out = File.open('proteins.fasta', 'w')

    pbar = ProgressBar.new 'dumping', proteins.count

    Scaffold.all.each do |scaffold|
      scaffold.features.each do |feature|
        pbar.inc
        out.puts ">#{feature.id}\n#{feature.protein_sequence}"
      end
    end

    pbar.finish
    out.close

  end
end
