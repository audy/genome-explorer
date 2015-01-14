# Load the Rails application.
require File.expand_path('../application', __FILE__)

# set default Delayed Job queue

Delayed::Worker.default_queue_name = 'default'

# Initialize the Rails application.
Rails.application.initialize!
