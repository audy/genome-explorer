require 'rails_helper'

describe Genome do

  let(:genome) { create(:genome) }

  it 'can be created' do
    expect(genome).to_not eq(nil)
  end

end
