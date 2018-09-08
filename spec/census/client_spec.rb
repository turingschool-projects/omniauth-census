require 'spec_helper'

describe Census::Client do
  describe '.generate_token' do
    it 'creates a token and returns credentials' do
      creds_json = {
        access_token: "biglongtoken",
        token_type: "bearer",
        expires_in: 12345,
        created_at: 1242597
      }.to_json
      response_stub = double(status: 201, body: creds_json)
      allow(Faraday).to receive(:post).and_return(response_stub)

      credentials = Census::Client.generate_token(client_id: 'foo', client_secret: 'bar')

      expect(credentials.access_token).to eq("biglongtoken")
    end
  end

  describe '#invite_user' do
    it 'returns the invitation id' do
      invite_id = 1
      invite_attributes = { "invitation"=> { "id"=>invite_id } }
      response_stub = double(status: 201, body: invite_attributes.to_json)
      allow(Faraday).to receive(:post).and_return(response_stub)
      client = Census::Client.new(token: "foo")

      invitation = client.invite_user(email: "invited@example.com", name: "Mildred")

      expect(invitation.id).to eq(invite_id)
    end
  end

  describe '#get_users' do
    it 'returns all the users' do
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
      }
      users = [user_attributes]
      response_stub = double(status: 200, body: users.to_json)
      allow(Faraday).to receive(:get).and_return(response_stub)
      client = Census::Client.new(token: "foo")

      users = client.get_users

      expect(users.first.id).to eq(86)
      expect(users.first.cohort_name).to eq("1401-BE")
    end
  end

  describe '#get_users_by_cohort_name' do
    it 'returns users associated with a cohort' do

      user_1_attributes = {
        "id"=>24,
        "first_name"=>"Sal",
        "last_name"=>"Espinosa",
        "cohort"=>{"id"=>13, "name"=>"1602-BE"},
        "cohort_id"=>13,
        "image_url"=>"https://img.example.com",
        "email"=>"foo@turing.io",
        "slack"=>"sl",
        "stackoverflow"=>"so",
        "linked_in"=>"li",
        "git_hub"=>"gh",
        "twitter"=>"tw",
        "roles"=>[
          {"id"=>21, "name"=>"full-circle-reviewer", "created_at"=>"2018-03-17T19:05:53.852Z", "updated_at"=>"2018-03-17T19:05:53.852Z"},
          {"id"=>17, "name"=>"admin", "created_at"=>"2017-02-14T22:18:26.978Z", "updated_at"=>"2017-02-14T22:18:26.978Z"},
          {"id"=>18, "name"=>"staff", "created_at"=>"2017-02-14T22:18:26.993Z", "updated_at"=>"2017-02-14T22:18:26.993Z"}
        ],
        "groups"=>["Golick"]
      }

      user_2_attributes = {
        "id"=>86,
        "first_name"=>"Simon",
        "last_name"=>"Tar",
        "cohort"=>{"id"=>1, "name"=>"1401-BE"},
        "cohort_id"=>1,
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
        "groups"=>["LGBTQ"]
      }


      users = [user_1_attributes, user_2_attributes]
      response_stub = double(status: 200, body: users.to_json)
      allow(Faraday).to receive(:get).and_return(response_stub)
      client = Census::Client.new(token: "foo")

      users = client.get_users_by_cohort_name("1602-BE")

      expect(users.first.id).to eq(24)
      expect(users.first.cohort_name).to eq("1602-BE")
    end
  end

  describe '#get_user_by_id' do
    it 'returns the requested user' do
      user_attributes = {
        "cohort"=>"1401-BE",
        "email"=>"foo@turing.io",
        "first_name"=>"Simon",
        "git_hub"=>"gh",
        "groups"=>["LGBTQ"],
        "id"=>86,
        "image_url"=>"https://img.example.com",
        "last_name"=>"Tar",
        "linked_in"=>"li",
        "roles"=> ["student"],
        "slack"=>"sl",
        "stackoverflow"=>"so",
        "twitter"=>"tw"
      }
      response_stub = double(status: 200, body: user_attributes.to_json)
      allow(Faraday).to receive(:get).and_return(response_stub)
      client = Census::Client.new(token: "foo")

      user = client.get_user_by_id(id: 86)

      expect(user.cohort_name).to eq("1401-BE")
    end
  end

  describe '#get_current_user' do
    it 'returns the user tied to the passed token' do
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

  describe '#get_cohorts' do
    it 'returns an array of CensusCohort objects' do
      cohort_attributes = [
        {"id"=>1,
         "name"=>"1406-BE",
         "start_date"=>"2014-06-01 00:00:00 UTC",
         "status"=>"closed"},
        {"id"=>2,
         "name"=>"1407-BE",
         "start_date"=>"2014-07-01 00:00:00 UTC",
         "status"=>"closed"},
        {"id"=>3,
         "name"=>"1409-BE",
         "start_date"=>"2014-09-01 00:00:00 UTC",
         "status"=>"opent"}
        ]

      response_stub = double(status: 200, body: cohort_attributes.to_json)
      allow(Faraday).to receive(:get).and_return(response_stub)

      client = Census::Client.new(token: "foo")

      cohorts = client.get_cohorts

      expect(cohorts.length).to eq(3)
      expect(cohorts.first.class).to eq(Census::Cohort)
      expect(cohorts.first.id).to eq(1)
      expect(cohorts.first.name).to eq("1406-BE")
      expect(cohorts.first.start_date).to eq("2014-06-01 00:00:00 UTC")
      expect(cohorts.first.status).to eq("closed")
    end
  end
end
