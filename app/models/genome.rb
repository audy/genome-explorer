require 'json'
require 'tempfile'
require 'zlib'

class Genome < ActiveRecord::Base
  has_many :scaffolds
  has_many :features

  validates :assembly_id, numericality: { only_integer: true }, presence: true

  after_create do
    self.pull_from_ncbi
  end

  def pull_from_ncbi

    @genome = self

    # get metadata from ncbi
    ncbi_res = `bionode-ncbi search assembly #{self.assembly_id}`
    p ncbi_res
    dat = JSON.parse(ncbi_res)

    # remove features and scaffolds if there are any
    @genome.features.delete_all
    @genome.scaffolds.delete_all

    @genome.update organism: dat['organism']

    dir = Dir.mktmpdir self.assembly_id.to_s
    Dir.chdir dir

    fna = JSON.parse(`bionode-ncbi download assembly #{self.assembly_id}`.split("\n").last)
    gff = JSON.parse(`bionode-ncbi download gff #{self.assembly_id}`.split("\n").last)

    # has to be loaded before features so that features can reference a
    # scaffold
    read_scaffolds(fna["path"]).each_slice(10) do |scaffolds|
      scaffolds.map! { |x| x.genome = @genome; x }
      Scaffold.import scaffolds
    end

    # has to be loaded after scaffolds
    read_features(gff["path"]).each_slice(1_000) do |features|
      features.map! { |x| x.genome = @genome; x }
      Feature.import features
    end

  end

#  handle_asynchronously :pull_from_ncbi
end

#
# Return an array of (unsaved) Scaffolds with sequence and scaffold_names
#
def read_scaffolds path
  Zlib::GzipReader.open(path) do |handle|
    Dna.new(handle, format: :fasta).map do |record|
      Scaffold.new(sequence: record.sequence, scaffold_name: record.name.split.first)
    end
  end
end

#
# Return an array of (unsaved) Features with attributes from specified GFF file.
#
def read_features path
  # memoize scaffold lookup
  scaffolds = Hash.new { |h,k| h[k] = Scaffold.find_by_scaffold_name(k) }

  Zlib::GzipReader.open(path) do |handle|
    handle.map do |line|
      next if line =~ /^#/
      dat = parse_gff(line)
      scaffold = scaffolds[dat['scaffold_name']]
      Feature.new(dat.slice(*Feature.column_names).merge(scaffold: scaffold))
    end.compact
  end
end

#
# Parse a GFF-formatted line, return a hash with column names as keys
# and column values as values.
#
def parse_gff(line)
  fields = line.strip.split("\t")

  scaffold_name = String fields[0]
  source        = String fields[1]
  feature_type  = String fields[2]
  start         = Integer fields[3] rescue nil
  stop          = Integer fields[4] rescue nil
  score         = Float fields[5] rescue nil
  strand        = String fields[6]
  frame         = Integer fields[7] rescue nil
  info          = String fields[8]

  { 'scaffold_name' => scaffold_name,
    'start'         => start,
    'source'        => source,
    'stop'          => stop,
    'strand'        => strand,
    'score'         => score,
    'feature_type'  => feature_type,
    'info'          => info }

end
