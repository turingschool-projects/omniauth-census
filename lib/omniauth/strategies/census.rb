require 'omniauth/strategies/oauth2'

module Omniauth
  module Strategies
    class Census < Omniauth::Strategies::OAuth2
      option :name, :census
      option :client_options, {
        :site => "http://localhost:3000"
        :authorize_url => "/oauth/authorize"
      }
    end
  end
end
