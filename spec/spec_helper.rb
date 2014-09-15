require 'bundler'

Bundler.require(:default, :test, :development)

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :logging, false
Sinatra::Base.set :raise_errors, true

require File.join(File.dirname(__FILE__), '..', 'application')

RSpec.configure do |config|


  config.before :all do
  end

  def app
    App
  end

end
