require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Census < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy
      option :client_options, {
               site: "https://localhost:3000",
               authorize_url: "https://localhost:3000/oauth/authorize",
               token_url: "https://localhost:3000/oauth/token"
             }
      def request_phase
        super
      end
      info do
        raw_info.merge("token" => access_token.token)
      end
      uid { raw_info["id"] }
      def raw_info
        @raw_info ||=
          access_token.get('/api/v1/users/me').parsed
      end
    end
  end
end
