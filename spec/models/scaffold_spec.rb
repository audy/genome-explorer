require 'rails_helper'

describe Scaffold do

  let (:scaffold) { FactoryGirl.build(:scaffold) }

  it 'can be created' do
    expect(scaffold).not_to eq(nil)
  end

end
