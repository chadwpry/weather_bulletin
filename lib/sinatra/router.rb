module Sinatra
  module Router
    CONFIGURATION = {}

    def self.included(klass)
      configure({
        routes_path: "#{WeatherBulletin::Application.root}/../../config/routes/**/*.rb",
        routes: []
      })

      Dir[CONFIGURATION[:routes_path]].each do |path|
        self.load_route(path)
      end
    end

    def self.configure(options = {})
      CONFIGURATION.merge!(options)
    end

    def self.load_route(path)
      puts "loading route: #{path}"
      require path
      CONFIGURATION[:routes] << path
    end
  end
end
