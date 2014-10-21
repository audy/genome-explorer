require 'rails_helper'

describe Scaffold do

  it 'can be created' do
    scaffold = FactoryGirl.build(:scaffold)
    expect(scaffold).not_to eq(nil)
  end

end
