source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

# database driver
gem 'pg'

# webserver
gem 'thin'

#
# JavaScript Business
#

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views
gem 'jquery-rails' # Use jquery as the JavaScript library

# 12 factor apps (see 12factor.net)
gem 'rails_12factor', group: :production

# For file attachments (mostly used for avatars)
gem 'carrierwave'

# Procedurally-generated avatars for Genomes
gem 'monsterid'

# markdown rendering
gem 'redcarpet'

# Layout/Template Stuff

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'will_paginate', '~> 3.0'
gem 'bootstrap-will_paginate'
gem 'haml'
gem 'haml-rails'

# Use SASS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Background-job stuff
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'progressbar'

# For speedily importing lots of records
gem 'activerecord-import'

# plotting stuff
gem 'chartkick'
gem 'groupdate'

# bioinformatics-related gems
gem 'dna'
gem 'bio'

# For debugging in production :D
gem 'pry'
gem 'pry-rails'

# error reporting to rollbar.io
gem 'rollbar', '~> 1.3.1'

# Spring speeds up development by keeping your application running in the
# background. Read more: https://github.com/rails/spring but also fucks
# everything up
group :development do

  # bundle exec foreman start to start the app and a worker
  gem 'foreman'

  # make loading app faster / breaks things
  gem 'spring'

  # for autoreloading and test running
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'

  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', group: :doc
end

group :test do

  gem 'cucumber-rails', require: false

  # silly codeclimate test coverage bage
  gem 'codeclimate-test-reporter', require: nil

  # cleans up databases
  gem 'database_cleaner'

  # generates models
  gem 'factory_girl_rails'

  # continuous integration
  gem 'travis'

  # Austin's favorite test engine
  gem 'rspec-rails'

end
