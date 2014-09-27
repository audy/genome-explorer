require 'test_helper'

class GenomesTest < ActionDispatch::IntegrationTest

  test 'it has an import button' do
    visit '/genomes'
    assert page.has_content?('Import')
  end

end
