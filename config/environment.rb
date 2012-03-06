# Load the rails application
require File.expand_path('../application', __FILE__)

Mime::Type.register 'application/vnd.tweetsecretary-v1+json', :v1_json

# Initialize the rails application
Tweetdisplay::Application.initialize!
