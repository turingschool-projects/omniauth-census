# Omniauth::Census

Welcome to Census, and Omniauth strategy for Census. This gem makes it possible
to log users into your application using their Turing Census loging
credentials.

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile

gem 'omniauth-census', git: "https://github.com/turingschool-projects/omniauth-census"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install omniauth-census

## Usage

#### Step 1: Register your Application

* Sign in to Census at [https://login.turing.io](https://login.turing.io).
* Visit [Your Census Applications](https://login.turing.io/oauth/applications) and register your app.
* Provide an application name
* Provide an application redirect uri (e.g. https://your-app.com/auth/census/callback)
* Note the values for "Application Id" and "Secret". These are your "production" values.
* Follow the steps above, but at <https://login-staging.turing.io>. You will
  get a different set of "Application Id" and "Secret". These are your
  "development" values.


#### Step 2: Configure OmniAuth

*   Add the `CENSUS_ID`, `CENSUS_SECRET` you receive to your application's environment variables. Use the "production" values if `RACK_ENV` is set to `production`. Use the "development" values for all other environments.
    *   For security, please ensure that these variables are not uploaded to GitHub or any other publicly available resource. If you need assistance with keeping these secret, consider using the [Figaro](https://github.com/laserlemon/figaro) gem. _(Figaro pronunciation: /fi.ɡa.ʁɔ/)_

*   Create the following file:
    `touch config/initializers/omniauth.rb`

*   Add the following configuration to the above file:
    ```ruby
    # config/initializers/omniauth.rb

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :census, "CENSUS_ID", "CENSUS_SECRET", {
        :name => "census"
      }
    end
    ```

#### Step 3: Setup Route
In your Rails application create the following routes:
```ruby
# config/routes.rb

get 'auth/:provider/callback', to: 'sessions#create'
```
#### Step 4: Create a Controller
In your Rails application create a controller that will handle the login process. For example:

`touch app/controllers/sessions_controller.rb`

In that controller include the following:

```ruby
# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  def create
    census_user_info = env["omniauth.auth"]
  end
end
```

#### Step 5: Add Login Link

Add the following code to your desired view in order to create a Census Login
Link

`<%= link_to 'Login with Census', '/auth/census' %>`

## Note about environments

Since you can perform destructive actions on Census with your application keys,
we host a "staging" and a "production" version of the Census app. That way, if
you have a bug in your code, you'll only screw up the "staging" app.

This gem is set to use the "production" host of Census if your application's
`RACK_ENV` variable is set to `production`, and staging for all other values of
`RACK_ENV` (including if it is unset).

Additionally, you can force use of the production server by setting an
environment variable `CENSUS_ENV=production`.

The Census endpoint can be overridden by setting a fully qualified URL in
`CENSUS_PROVIDER_ENDPOINT`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/turingschool-projects/omniauth-census.

## Releasing a new version

* Make your changes and go through the pull request process.
* Merge to master.
* Update the version number in `version.rb`
* Make a new commit with something like `git commit -m "Bumping version to 0.1.2"`
* Then run `git tag v0.1.2`
* Then run `git push && git push --tags`

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
