require 'rails_helper'

describe 'the welcome page', type: :feature do
  it 'says welcome' do
    visit '/'
    expect(page).to have_content('Welcome')
  end
end
