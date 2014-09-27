require 'test_helper'

class WelcomeTest < ActionDispatch::IntegrationTest

  test 'I visit the welcome page' do
    visit '/'

    within 'body' do
      assert page.has_content?('Genome')
    end

    within 'nav' do
      assert page.has_content?('Genomes')
    end

  end

end
