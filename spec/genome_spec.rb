require 'spec_helper'

describe Genome do
  let (:genome) { Genome.new.save }

  it 'can have friends' do
    genome.update({ friendships: [ genome ] })
    genome.save

    expect(Genome[genome.id].friends.size).not_to eq(0)
  end

end
