require 'census/user'

module Census
  class Client
    BASE_URL = OmniAuth::Strategies::Census.provider_endpoint

    class InvalidResponseError < StandardError; end;
    class UnauthorizedError < StandardError; end;
    class NotFoundError < StandardError; end;

    def initialize(token:)
      @token = token
    end

    def get_current_user
      response = Faraday.get(user_url)

      begin
        response_json = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise InvalidResponseError.new(e.message)
      end

      if response.status == 401
        raise UnauthorizedError.new(parse_errors(response_json))
      elsif response.status == 404
        raise NotFoundError.new(parse_errors(response_json))
      end

      map_response_to_user(response_json)
    end

    private

    def map_response_to_user(user_json)
      Census::User.new(
        cohort_name: (user_json["cohort"] || {})["name"],
        email: user_json["email"],
        first_name: user_json["first_name"],
        git_hub: user_json["git_hub"],
        groups: user_json["groups"].map { |group| group["name"] },
        id: user_json["id"],
        image_url: user_json["image_url"],
        last_name: user_json["last_name"],
        roles: user_json["roles"].map { |role| role["name"] },
        slack: user_json["slack"],
        stackoverflow: user_json["stackoverflow"],
        twitter: user_json["twitter"],
      )
    end

    def parse_errors(response_json)
      response_json["errors"].join(",")
    end

    def user_url
      user_url = "/api/v1/user_credentials"

      BASE_URL + user_url + "?access_token=#{@token}"
    end
  end
end
