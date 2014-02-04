require "sinatra/authentication"
require "sinatra/router"
require "weather_bulletin"

module WeatherBulletin
  class Application < Sinatra::Base
    configure do
      set :haml, format: :html5
      set :logging, true
      set :sessions, true
      set :inline_templates, true
    end

    include Sinatra::Authentication
    include Sinatra::Router

    authenticate only: ["/profile"],
      on_create: -> (env) {User.find_by(env)},
      on_read: -> (id) {User.where(id: id).first}

    use OmniAuth::Builder do
      provider :twitter, ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"]
    end

    get '/' do
      haml :index
    end

    get '/profile' do
      <<-HTML
        Profile Page
        #{current_user.name}
      HTML
    end
  end
end
