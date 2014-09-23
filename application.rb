require './environment.rb'
require 'sinatra'

# models must be required *after* calling Sequel.connect
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |f| require f }

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
    @page = (params[:page] || 1).to_i
    paginated = DB[:genomes].order(:id).paginate(@page, 25)
    @total_pages = paginated.page_count
    @genomes = paginated.all
    haml :home
  end

  get '/genome/:id' do
    @genome = Genome[params[:id]]

    @page = (params[:page] || 1).to_i
    paginated = Feature.dataset.where(type: 'CDS').order(:id).paginate(@page, 25)
    @total_pages = paginated.page_count
    @features = paginated.all

    haml :'genome/view'
  end

  get '/feature/:id' do
    @feature = Feature[params[:id]]
    haml :'feature/view'
  end

  get '/genome/pic/:id.png' do
    response.headers['content_type'] = 'image/png'
    response.write(MonsterID.new(Digest::MD5.hexdigest(params[:id])).to_datastream)
  end

end
