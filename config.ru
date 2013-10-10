require 'rubygems'
require 'bundler'

Bundler.require(:default)
require "./mailchimp_endpoint"
run MailChimpEndpoint
