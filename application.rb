require './environment.rb'
require 'sinatra'

class App < Sinatra::Base

  enable :sessions

  register Sinatra::AssetPack

  assets do
    serve '/js',     from: 'assets/js'
    serve '/css',    from: 'assets/css'
    serve '/images', from: 'assets/images'

    css :main, ['/css/*.css']
    js :main, ['/js/jquery.*.js', '/js/bootstrap.*.js']

    css_compression :simple
    js_compression :uglify
  end

  get '/' do
    @genomes = Genome.all
    haml :home
  end

end
