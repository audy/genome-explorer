require './application.rb'

require 'yaml'

App::DB.loggers = []

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
    Feature.where(type: 'CDS', strand: '.').each do |feat|
      unless feat.sequence =~ /^ATG/
        puts ">#{feat.id} #{feat.strand} #{feat.frame} #{feat.genome_id} #{feat.info}\n#{feat.sequence}"
      end
    end
  end
end

namespace :stat do
  desc 'print start codon usage statistics'
  task :codons do
    counts = Hash.new { |h,k| h[k] = 0 }
    pbar = ProgressBar.new 'counting', 1_000
    Feature.where(Sequel.~(strand: '.')).first(1_000).each do |feat|
      pbar.inc
      counts[feat.sequence[0..2]] += 1
    end
    pbar.finish
    puts counts.to_yaml
  end
end
