require 'sinatra'
require 'bcrypt'
require 'bundler'

Bundler.require :default


class Skellington < Sinatra::Base

  # finalize models and connect to database
  Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |f| require f }

  DataMapper.setup :default, ENV['DATABASE_URL'] || "postgres://#{ENV['USER']}@127.0.0.1/genome"
  # DataMapper.repository(:default).adapter.execute("CREATE EXTENSION HSTORE")
  DataMapper.finalize

  # construct default :public_folder and :views
  set :root, File.dirname(__FILE__)


  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  configure :production do
  end

  configure :test do
  end

end
