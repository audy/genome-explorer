class Genome
  include DataMapper::Resource

  property :id, Serial

  property :tax_id, Integer # NCBI taxonomy database

  has n, :scaffolds
end

class Scaffold
  include DataMapper::Resource

  property :id, Serial

  property :nucleotides_file, String

  belongs_to :genome
  has n, :features

  def sequences
    Dna.new(File.readlines(self.nucleotides_file), format: :fasta).to_a
  end
end

class Feature
  include DataMapper::Resource
  belongs_to :scaffold

  property :id, Serial

  property :start, Integer
  property :stop, Integer
  property :score, Float
  property :strand, Enum[:forward, :reverse]
  property :type, Enum[:CDS]
end
