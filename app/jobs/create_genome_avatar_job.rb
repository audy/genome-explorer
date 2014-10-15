CreateGenomeAvatarJob = Struct.new(:id) do
  def perform
    @genome = Genome.find(self.id)
    file = Tempfile.new('monsterid')
    MonsterID.new(self.id).save(file.path)
    @genome.update({ avatar: File.open(file.path) })
    file.unlink
  end
  
  def queue
    'local' # must run were app has access to data/
  end
end
