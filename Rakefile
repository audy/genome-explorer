# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :version do
  desc 'print current version number to STDOUT'
  task :show do
    puts Omgenomes::Version::STRING
  end

  desc 'increment version number'
  task :bump do
  end
end
