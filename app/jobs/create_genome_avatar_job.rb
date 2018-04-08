CreateGenomeAvatarJob = Struct.new(:genome_id) do
  def perform
    @genome = Genome.find(self.genome_id)
    file = Tempfile.new('monsterid')
    MonsterID.new(self.genome_id).save(file.path)
    @genome.update({ avatar: File.open(file.path) })
    file.unlink
    return file.path
  end

  def queue_name
    'default'
  end
end
