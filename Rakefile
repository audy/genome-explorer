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
  task :load => :environment do

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

  desc 'load similarities from blast-like tabular output and create similar proteins'
  task :load => :environment do
    ActiveRecord::Base.logger.level = 1
    ProteinRelationship.delete_all
    File.open('all-v-all-usearch.blast6.tab') do |handle|
#      RubyProf.start
      pbar = ProgressBar.new 'loading', File.size(handle.path)
      columns = [ :feature_id, :related_feature_id ]
      read_blast_file(handle).each_slice(10_000) do |values|
        pbar.set handle.pos
        ProteinRelationship.import columns, values, validate: false
      end
      pbar.finish
#      result = RubyProf.stop
#      printer = RubyProf::GraphPrinter.new(result)
#      printer.print(STDOUT, {})
    end
  end

end

def yield_protein_relationships handle
  Enumerator.new do |enum|
    read_blast_file(handle).each do |dat|
      dat
      enum.yield ProteinRelationship.new feature_id: dat[0],
                                         related_feature_id: dat[1],
                                         info: { identity: dat[2] }
    end
  end
end

def read_blast_file handle
  Enumerator.new do |enum|
    handle.each do |line|
      enum.yield parse_blast_line(line)
    end
  end
end

def parse_blast_line line
  fields = line.strip.split("\t")
#  {
#    :query_id      => Integer(fields[0]),
#    :subject_id    => Integer(fields[1]),
#    :identity      => Float(fields[2]),
#    :length        => Integer(fields[3]),
#    :mismatch      => Integer(fields[4]),
#    :gapopen       => Integer(fields[5]),
#    :query_start   => Integer(fields[6]),
#    :query_end     => Integer(fields[7]),
#    :subject_start => Integer(fields[8]),
#    :subject_end   => Integer(fields[9]),
#    :evalue        => Float(fields[10]),
#    :bitscore      => Float(fields[11])
#  }
  # query, subject, identity
  [ fields[0],
    fields[1] ]
end
