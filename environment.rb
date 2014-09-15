require 'bundler'

Bundler.require

class Skellington < Sinatra::Base

  # construct default :public_folder and :views
  set :root, File.dirname(__FILE__)

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Sequel.connect('sqlite://development.sqlite')
  end

  configure :production do
    Sequel.connect(ENV['DATABASE_URL'] ||
                   "postgres://#{ENV['USER']}@127.0.0.1/genome")
  end

  configure :test do
    db = Sequel.sqlite
    Sequel.extension :migration
    Sequel::Migrator.run(db, 'migrations')
  end

  # require models after calling Sequel.connect
  Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |f| require f }
end


