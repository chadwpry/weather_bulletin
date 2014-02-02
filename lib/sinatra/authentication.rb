module Sinatra
  module Authentication
    DEFAULT_CONFIGURATION = {}
    CONFIGURATION = DEFAULT_CONFIGURATION.dup

    def self.included(klass)
      raise "Authentication requires sessions" unless klass.sessions

      klass.get '/auth/:name/callback' do
        @current_user = CONFIGURATION[:on_create].call(omniauth_auth)
        session['entity_id'] = @current_user.id
        redirect "/profile"
      end

      def klass.authenticate(options = {})
        (CONFIGURATION.merge!(options)[:only] || []).each do |route|
          before route do
            authenticate!
          end
        end
      end
    end

    def authenticate!
      redirect("/auth/twitter") unless current_user
    end

    def current_user
      @current_user || CONFIGURATION[:on_read].call(session['entity_id'])
    end

    private

    def omniauth_auth
      request.env['omniauth.auth']
    end
  end
end
