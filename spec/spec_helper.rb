require 'bundler'

Bundler.require(:default, :test)

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :logging, false
Sinatra::Base.set :raise_errors, true

require File.join(File.dirname(__FILE__), '..', 'application')

RSpec.configure do |config|

  def app
    Skellington
  end

  config.before(:each) { DataMapper.auto_migrate! }

  config.include Rack::Test::Methods
end
