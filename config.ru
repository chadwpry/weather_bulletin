require "omniauth"
require "omniauth-twitter"
require "mongoid"
require "sinatra"

$:.unshift "./lib"

require "weather_bulletin/application"

ENV['RACK_ENV'] = 'development'

require "pry" if ENV['RACK_ENV'] == "development"

Mongoid.load! "./config/mongoid.yml"

run WeatherBulletin::Application.run!
