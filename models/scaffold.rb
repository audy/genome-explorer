class Scaffold
  include DataMapper::Resource

  property :id, Serial
  property :sequence, Text, length: 10_000_000 # 10 megabases

  belongs_to :genome
  has n, :annotations

  def size
    self.sequence.size
  end

  def wrap c
    self.sequence.split('').each_slice(c).map(&:join).to_a.join("\n")
  end
end
