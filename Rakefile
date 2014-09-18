require './application.rb'

Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each { |f| require f }

desc 'start application console'
task :console do
  ARGV.clear
  Pry.start
end

namespace :db do
  desc 'run migrations'
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(App::DB,
                           'migrations',
                           target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(App::DB, 'migrations')
    end
  end

  desc 'drop tables'
  task :drop do
    App::DB.tables.each do |table|
      puts "dropping #{table}"
      App::DB.drop_table(table)
    end
  end

  desc 'rollback'
  task :rollback, :env do |cmd, args|

  end
end

namespace :dump do
  desc 'dump gene products to fasta (nucleotide)'
  task :gene_products do
    App::DB.loggers = []
    Feature.where(type: 'CDS').each do |feat|
      puts ">#{feat.id} #{feat.genome_id} #{feat.info}\n#{feat.sequence}"
    end
  end
end
