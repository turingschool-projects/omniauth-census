# Omniauth::Census

Welcome to Census, and Omniauth strategy for Census. This gem makes it possible to log users into your application using their Turing Census loging credentials.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-census', git: "https://github.com/bcgoss/omniauth-census"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-census

## Usage
#### Step 1: Register your Application
Visit [Your Census Applications ](http://census-app-staging.herokuapp.com/oauth/applications) and register your app.
* Provide an application name
* Provide an application redirect uri (e.g. http://localhost:3000/auth/census/callback)
* Optionally, provide a scope (note this feature is still in development)  
#### Step 2: Create an OmniAuth Config Initializer
Create the following file:
`touch config/initializers/omniauth.rb`

Add the following configuration to the above file:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :census, "CENSUS_ID", "CENSUS_SECRET", {
    :name => "census"
  }
end
```
#### Step 3: Setup Route
In your Rails application create the following routes:
```ruby
get 'auth/:provider/callback', to: 'sessions#create'
```
#### Step 4: Create a Controller
In your Rails application create a controller that will handle the login process. For example:

`touch app/controllers/sessions_controller.rb`

In that controller include the following:

```ruby
class SessionsController < ApplicationController
  def create
    census_user_info = env["omniauth.auth"]
  end
end
```

#### Step 5: Add Login Link

Add the following code to your desired view in order to create a Census Login Link

`<%= link_to 'Login with Census', '/auth/census' %>`

## Important note
Please note that in order to use the Census OmniAuth strategy, your application must be configured to handle secured HTTPS requests. This is not the default setting on typical Rails applications run locally. For instructions on configuring SSL on a development version of your application, please consult [this guide](http://blog.napcs.com/2013/07/21/rails_ssl_simple_wa/).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bcgoss/omniauth-census.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
