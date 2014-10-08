# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :proteins do

  desc 'dump all proteins to proteins.fasta'
  task :dump => :environment do
    DumpProteinsToFileJob.new('proteins.fasta').perform
  end

  task :relationships => :environment do
    FindRelatedProteinsJob.new.perform
  end

end
