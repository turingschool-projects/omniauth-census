require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Census < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy
      option :client_options, {
               site: "https://census-app-staging.herokuapp.com",
               authorize_url: "/oauth/authorize",
               token_url: "/oauth/token"
             }

      def request_phase
        super
      end

      def callback_url
        full_host + script_name + callback_path
      end

      info do
        raw_info.merge("token" => access_token.token)
      end

      uid { raw_info["id"] }

      def raw_info
        @raw_info ||=
          access_token.get('/api/v1/user').parsed
      end

    end
  end
end
