require "omniauth"
require "omniauth-twitter"
require "mongoid"
require "sinatra"

$:.unshift "./lib"

require "weather_bulletin/application"

ENV['RACK_ENV'] = 'development'

require "pry" if ENV['DEBUG'] == "true"

Mongoid.load! "./config/mongoid.yml"

WeatherBulletin::Application.root = "#{File.dirname(__FILE__)}"

run WeatherBulletin::Application.run!
