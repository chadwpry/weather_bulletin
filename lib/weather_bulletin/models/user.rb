require "open-uri"
require "oauth"

module WeatherBulletin
  class User
    include Mongoid::Document
    include Mongoid::Paranoia
    include Mongoid::Timestamps

    FORECAST_ICONS = {
      "clear-day" => "☀",
      "clear-night" => "☽",
      "cloudy" => "☁",
      "fog" => "",
      "hail" => "",
      "partly-cloudy-day" => "☁ ☀",
      "partly-cloudy-night" => "☁",
      "rain" => "☂",
      "sleet" => "",
      "snow" => "☃",
      "thunderstorm" => "☈",
      "tornado" => "",
      "wind" => "",
    }

    field :provider
    field :uid
    field :nickname
    field :name
    field :location
    field :image
    field :description
    field :credentials, type: Hash

    index({provider: 1, uid: 1}, {unique: true})

    def self.find_by(env)
      user = User.find_or_initialize_by(provider: env["provider"], uid: env["uid"])

      user.nickname = env["info"]["nickname"]
      user.name     = strip_weather(env["info"]["name"])
      user.location = env["info"]["location"]
      user.image    = env["info"]["image"]
      user.description = env["info"]["description"]
      user.credentials = env["credentials"]

      user.save
      user
    end

    def strip_weather(input_name)
      input_name.strip!
      FORECAST_ICONS.values.each do |icon|
        input_name.gsub!(" #{icon}", "")
      end
      input_name
    end

    def current_weather
      weather["currently"]
    end

    def current_weather_icon
      current_weather["icon"]
    end

    def geocode
      @geocode = JSON.parse(open(URI.encode("http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=#{location}")).string)["results"].first["geometry"]
    end

    def latitude
      geocode["location"]["lat"]
    end

    def longitude
      geocode["location"]["lng"]
    end

    def token_hash
      {
        :oauth_token => credentials["token"],
        :oauth_token_secret => credentials["secret"]
      }
    end

    def twitter_access_token
      consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], {
        site: "https://api.twitter.com", scheme: :header
      })

      OAuth::AccessToken.from_hash(consumer, token_hash)
    end

    def update_twitter_name
      twitter_access_token.post "https://api.twitter.com/1.1/account/update_profile.json", {name: "#{name} #{weather_icon}"}
    end

    def update_twitter_header_image
      twitter_access_token.post "https://api.twitter.com/1.1/account/update_profile_banner.json", {banner: weather_image_base64}
    end

    def weather
      @weather ||= JSON.parse(open(URI.encode("https://api.forecast.io/forecast/#{ENV['FORECAST_API_KEY']}/#{latitude},#{longitude}")).read)
    end

    def weather_icon
      FORECAST_ICONS[current_weather_icon]
    end

    def weather_image
      "public/images/#{current_weather_icon}.jpg"
    end

    def weather_image_base64
      Base64.encode64 File.read(weather_image)
    end
  end
end
