module Census
  class Credentials
    attr_reader(
      :access_token,
      :token_type,
      :expires_in,
      :created_at
    )

    def initialize(
      access_token:,
      token_type:,
      expires_in:,
      created_at:
    )
      @access_token = access_token
      @token_type = token_type
      @expires_in = expires_in
      @created_at = created_at
    end
  end
end
