source 'http://rubygems.org'

ruby '2.1.2'

gem 'sinatra'
gem 'rake'
gem 'haml'
gem 'pry'

gem 'sequel'
gem 'pg'

# bioinformatics
gem 'dna'

gem 'sinatra-assetpack', :require => 'sinatra/assetpack', :git => 'git://github.com/rstacruz/sinatra-assetpack.git'
gem 'uglifier'

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'rspec'
  gem 'rack-test', :require => 'rack/test'
end


group :development do
  gem 'sinatra-reloader'
end
