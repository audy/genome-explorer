require 'rails_helper'

describe CreateGenomeAvatarJob do

  let(:genome) { Genome.create assembly_id: 42 }
  let(:create_genome_avatar_job) { CreateGenomeAvatarJob.new(genome.id) }

  it 'can be created' do
    expect(create_genome_avatar_job).to_not be(nil)
  end
  
  it 'can be run resulting in an avatar' do
    create_genome_avatar_job.perform
    # gotta reload genome after update :)
    expect(genome.reload.avatar.url).to_not be(nil)
  end

  it 'creates an file (image)' do
    create_genome_avatar_job.perform
    path = './public/' + genome.reload.avatar.url
    expect(File.exists?(path)).to_not be(false)
  end

end
