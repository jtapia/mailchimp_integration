source 'https://rubygems.org'

gem 'capistrano'
gem 'mailchimp'
gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'activesupport'

group :development do
  gem 'pry'
  gem 'awesome_print'
end

group :test do
  gem 'vcr'
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

gem 'endpoint_base', git: 'git@github.com:spree/endpoint_base.git'
