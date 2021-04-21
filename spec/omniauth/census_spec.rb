require "spec_helper"

describe Omniauth::Census do
  it "has a version number" do
    expect(Omniauth::Census::VERSION).not_to be nil
  end

  context ".provider_endpoint" do
    it "returns the staging url by default" do
      expect(OmniAuth::Strategies::Census.provider_endpoint).to eq("https://login-staging.turing.edu")
    end

    it "returns the production url if rack_env is production" do
      safe_env({'RACK_ENV' => 'production'}) do
        expect(OmniAuth::Strategies::Census.provider_endpoint).to eq("https://login.turing.edu")
      end
    end

    it "returns the production url if census_env is production" do
      safe_env({'CENSUS_ENV' => 'production'}) do
        expect(OmniAuth::Strategies::Census.provider_endpoint).to eq("https://login.turing.edu")
      end
    end

    it "returns the given url if present in the environment" do
      safe_env({
        'CENSUS_ENV' => 'production',
        'CENSUS_PROVIDER_ENDPOINT' => 'https://foo.example.com'
      }) do
        expect(OmniAuth::Strategies::Census.provider_endpoint).to eq("https://foo.example.com")
      end
    end
  end


  it "Will set the correct auth_url given the environment" do
    expect(OmniAuth::Strategies::Census.provider_endpoint).to eq("https://login-staging.turing.edu")
  end
end

def safe_env(env_hash)
  old_env = ENV.to_hash

  env_hash.each do |key, value|
    ENV[key.to_s] = value
  end

  yield
ensure
  old_env.each do |key, value|
    ENV[key.to_s] = value
  end
end
