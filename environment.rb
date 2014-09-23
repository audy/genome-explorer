require 'logger'
require 'json'

require 'bundler'

Bundler.require

require './helpers.rb'

class App < Sinatra::Base

  # construct default :public_folder and :views
  set :root, File.dirname(__FILE__)

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://#{ENV['USER']}@127.0.0.1/genome")
    DB.loggers << Logger.new($stderr)
  end

  configure :production do
    DB = Sequel.connect(ENV['DATABASE_URL'] ||
                   "postgres://#{ENV['USER']}@127.0.0.1/genome")
  end

  configure :test do
    DB = Sequel.sqlite
    Sequel.extension :migration
    Sequel::Migrator.run(App::DB, 'migrations')
  end

  DB.extension(:pagination)

end
