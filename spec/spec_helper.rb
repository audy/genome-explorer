require 'bundler'

Bundler.require(:default, :test, :development)

Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :logging, false
Sinatra::Base.set :raise_errors, true

require File.join(File.dirname(__FILE__), '..', 'application')

RSpec.configure do |config|

  # run tests in their own transaction, rolling back afterwards this ensures
  # that tests are isolated.
  config.around(:each) do |example|
    App::DB.transaction rollback: :always, auto_savepoint: true do 
      example.run
    end
  end

  def app
    App
  end

end
