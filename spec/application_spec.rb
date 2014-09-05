require File.join(File.dirname(__FILE__), 'spec_helper')

describe Skellington do

  it 'should load the index page successfully' do
    get '/'
    last_response.should be_ok
  end
end
