require 'spec_helper'

describe Census::Client do
  describe '#get_current_user' do
    it 'does a thing' do
      user_attributes = {
        "id"=>86,
        "first_name"=>"Simon",
        "last_name"=>"Tar",
        "cohort"=>{"name"=>"1401-BE"},
        "image_url"=>"https://img.example.com",
        "email"=>"foo@turing.io",
        "slack"=>"sl",
        "stackoverflow"=>"so",
        "linked_in"=>"li",
        "git_hub"=>"gh",
        "twitter"=>"tw",
        "roles"=> [
          {"id"=>27, "name"=>"staff", "created_at"=>"2017-02-08T21:09:38.545Z", "updated_at"=>"2017-02-08T21:09:38.545Z"},
          {"id"=>1, "name"=>"admin", "created_at"=>"2016-12-21T21:11:33.140Z", "updated_at"=>"2016-12-21T21:11:33.140Z"}
         ],
        "groups"=>[{ "name"=>"LGBTQ" }],
        "token"=>"foo"
      }

      response_stub = double(status: 200, body: user_attributes.to_json)
      allow(Faraday).to receive(:get).and_return(response_stub)

      client = Census::Client.new(token: "foo")

      user = client.get_current_user

      expect(user.cohort_name).to eq("1401-BE")
      expect(user.email).to eq("foo@turing.io")
      expect(user.first_name).to eq("Simon")
      expect(user.git_hub).to eq("gh")
      expect(user.groups).to match_array(["LGBTQ"])
      expect(user.id).to eq(86)
      expect(user.image_url).to eq("https://img.example.com")
      expect(user.last_name).to eq("Tar")
      expect(user.roles).to match_array(["admin", "staff"])
      expect(user.slack).to eq("sl")
      expect(user.stackoverflow).to eq("so")
      expect(user.twitter).to eq("tw")
    end

    context 'with a not found user' do
      it 'raises auth error' do
        response_stub = double(status: 404, body: { errors: ["foo"] }.to_json )
        allow(Faraday).to receive(:get).and_return(response_stub)

        client = Census::Client.new(token: "valid-token")

        expect {
          client.get_current_user
        }.to raise_error(Census::Client::NotFoundError)
      end
    end

    context 'with invalid token' do
      it 'raises auth error' do
        response_stub = double(status: 401, body: { errors: ["foo"] }.to_json )
        allow(Faraday).to receive(:get).and_return(response_stub)

        client = Census::Client.new(token: "foo")

        expect {
          client.get_current_user
        }.to raise_error(Census::Client::UnauthorizedError)
      end
    end
  end
end
