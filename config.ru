require "rubygems"
require "bundler"

Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require_relative "./forum.rb"
use Rack::MethodOverride

run Forum::Server