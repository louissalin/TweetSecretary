require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'

gem 'rails', '3.2.1'
gem "bson_ext", ">= 1.3.1"
gem "mongoid", ">= 2.3.3"
gem "devise", ">= 1.5.0"
gem "twitter-bootstrap-rails"
gem "heroku"
gem 'jquery-rails'
gem "haml", ">= 3.1.2"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
    gem "haml-rails", ">= 0.3.4"
    gem "rspec-rails", ">= 2.8.0.rc1"
    gem "guard", ">= 0.6.2"
    gem "guard-bundler", ">= 0.1.3"
    gem "guard-rails", ">= 0.0.3"
    gem "guard-livereload", ">= 0.3.0"
    gem "guard-rspec", ">= 0.4.3"
    gem "guard-cucumber", ">= 0.6.1"
    gem "spork"
end

group :test do
    gem "rspec-rails", ">= 2.8.0.rc1"
    gem "database_cleaner", ">= 0.7.0"
    gem "mongoid-rspec", ">= 1.4.4"
    gem "factory_girl_rails", ">= 1.4.0"
    gem "cucumber-rails", ">= 1.2.0"
    gem "capybara", ">= 1.1.2"
    gem "launchy", ">= 2.0.5"
end

group :production do
    gem "thin"
end

case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
  when /linux/i
    gem 'therubyracer', '>= 0.9.8'
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
  when /mswin|windows/i
    gem 'rb-fchange', :group => :development
    gem 'win32console', :group => :development
    gem 'rb-notifu', :group => :development
end
