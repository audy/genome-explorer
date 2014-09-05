require './environment.rb'

Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rb')].each { |f| require f }

desc 'start application console'
task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end

desc 'run specs'
task :spec do
  sh 'rspec'
end

namespace :db do
  desc 'seed the database with information'
  task :seed do
  end
  
  desc 'auto-migrate the database (deletes data)'
  task :migrate do
    fail 'never auto_migrate! on the production server!' if $ENVIRONMENT == :production
    DataMapper.auto_migrate!
  end

  desc 'auto-upgrade the database schema (data safe)'
  task :upgrade do
    DataMapper.auto_upgrade!
  end
end
