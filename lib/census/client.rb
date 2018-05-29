require 'census/credentials'
require 'census/invitation'
require 'census/user'

module Census
  class Client
    BASE_URL = OmniAuth::Strategies::Census.provider_endpoint

    class InvalidResponseError < StandardError; end;
    class UnauthorizedError < StandardError; end;
    class NotFoundError < StandardError; end;
    class UnprocessableEntityError < StandardError; end;

    def initialize(token:)
      @token = token
    end

    def self.generate_token(client_id:, client_secret:)
      response = Faraday.post(
        BASE_URL + "/oauth/token",
        {
          grant_type: 'client_credentials',
          client_id: client_id,
          client_secret: client_secret,
          scope: "admin"
        }
      )

      begin
        response_json = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise InvalidResponseError.new(e.message)
      end

      if [401, 403].include?(response.status)
        raise UnauthorizedError.new(response_json["error"])
      elsif response.status == 404
        raise NotFoundError.new(response_json["error"])
      end

      Census::Credentials.new(
        access_token: response_json["access_token"],
        token_type: response_json["token_type"],
        expires_in: response_json["expires_in"],
        created_at: response_json["created_at"]
      )
    end

    # requires admin scope
    def invite_user(email:, name: nil)
      response_json = post_url(
        url: invitations_url,
        params: { invitation: { email: email, name: name } }
      )

      Census::Invitation.new(id: response_json["invitation"]["id"])
    end

    def get_current_user
      response_json = get_url(url: user_url)
      map_response_to_user(response_json)
    end

    def get_user_by_id(id:)
      response_json = get_url(url: single_user_url(id: id))

      Census::User.new(
        cohort_name: response_json["cohort"],
        email: response_json["email"],
        first_name: response_json["first_name"],
        git_hub: response_json["git_hub"],
        groups: response_json["groups"],
        id: response_json["id"],
        image_url: response_json["image_url"],
        last_name: response_json["last_name"],
        roles: response_json["roles"],
        slack: response_json["slack"],
        stackoverflow: response_json["stackoverflow"],
        twitter: response_json["twitter"]
      )
    end

    def get_users(limit: 100, offset: 0)
      paginated_url = build_full_url_with_token(path: "/api/v1/users") + "&limit=#{limit}&offset=#{offset}"
      response_json = get_url(url: paginated_url)

      response_json.map do |census_user|
        map_response_to_user(census_user)
      end
    end

    private

    def post_url(url:, params: {})
      response = Faraday.post(url, params)
      handle_and_parse_response(response: response)
    end

    def get_url(url:)
      response = Faraday.get(url)
      handle_and_parse_response(response: response)
    end

    def handle_and_parse_response(response:)
      begin
        response_json = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise InvalidResponseError.new(e.message)
      end

      if [401, 403].include?(response.status)
        raise UnauthorizedError.new(parse_errors(response_json))
      elsif response.status == 404
        raise NotFoundError.new(parse_errors(response_json))
      elsif response.status == 422
        raise UnprocessableEntityError.new(parse_errors(response_json))
      end

      response_json
    end

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

    def invitations_url
      build_full_url_with_token(path: "/api/v1/admin/invitations")
    end

    def user_url
      build_full_url_with_token(path: "/api/v1/user_credentials")
    end

    def single_user_url(id:)
      build_full_url_with_token(path: "/api/v1/users/#{id}")
    end

    def build_full_url_with_token(path:)
      BASE_URL + path + "?access_token=#{@token}"
    end
  end
end
