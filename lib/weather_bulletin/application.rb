require "sinatra/authentication"
require "weather_bulletin"

module WeatherBulletin
  class Application < Sinatra::Base
    configure do
      set :haml, format: :html5
      set :logging, true
      set :sessions, true
    end

    include Sinatra::Authentication

    authenticate only: ["/profile"],
      on_auth_route: -> (request) {"/auth/twitter"},
      on_auth_complete: -> (env) {"/profile"},
      on_create: -> (env) {User.find_by(env)},
      on_read: -> (id) {User.where(id: id).first}

    use OmniAuth::Builder do
      provider :twitter, ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"]
    end

    get '/' do
      haml :index
    end

    get '/profile' do
      @current_user = current_user
      @themes = ["Original"]
      haml :profile
    end
  end
end
