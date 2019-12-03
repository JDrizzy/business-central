# Business Central API Library

This library is designed to help ruby/rails based applications communicate with the publicly available API for dynamics 365 business central.

If you are unfamiliar with the business central API, you should first read the documentation located at https://docs.microsoft.com/en-us/dynamics-nav/api-reference/v1.0/.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'business-central'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install business-central

## Basic Usage

This gem supports both authentication methods:

https://docs.microsoft.com/en-us/dynamics-nav/api-reference/v1.0/endpoints-apis-for-dynamics

### Basic Authentication:

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-connect-apps#setting-up-basic-authentication

```Ruby
require 'business_central'

client = BusinessCentral::Client.new(
    username: '<username>',
    password: '<password>',
    url: '<url>'
)

# Find all vendors
vendors = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').find_all

# Find vendor by ID
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').find_by_id('3f445b08-2ffd-4f9d-81a0-b82f0d9714c4')

# Query vendor by display name
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').where("displayName eq 'First Up Consultants'")

# Create a new vendor
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').create({ display_name: 'hello testing new vendor' })

# Update an existing vendor by ID
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').update('3f445b08-2ffd-4f9d-81a0-b82f0d9714c4', { phone_number: '1112' })

# Delete a vendor
client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').destroy('f0730ada-b315-ea11-a813-000d3ad21e99')
```

### Oauth2 Authentication

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-connect-apps#AAD

```Ruby
require 'business_central'

# Create client - used to connect to the API
client = BusinessCentral::Client.new(
    tenant_id: '<tenant_id>',
    application_id: '<application_id>',
    secret_key: '<application_secret_key>',
    url: '<url>'
)

# Controller endpoint 1
client.authorize({ state: '1234' }, oauth_authorize_callback: redirect_url )

# Redirect URL endpoint - safely store the token to be re-used later
token = client.request_token(params[:code], oauth_token_callback: redirect_url)

client.authorize_from_token(
    token: token.token,
    refresh_token: token.refresh_token,
    expires_at: DateTime.current + 3600,
    expires_in: 3600
)

# Find all vendors
vendors = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').find_all

# Find vendor by ID
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').find_by_id('3f445b08-2ffd-4f9d-81a0-b82f0d9714c4')

# Query vendor by display name
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').where("displayName eq 'First Up Consultants'")

# Create a new vendor
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').create({ display_name: 'hello testing' })

# Update an existing vendor by ID
vendor = client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').update('3f445b08-2ffd-4f9d-81a0-b82f0d9714c4', { phone_number: '1112' })

# Delete a vendor
client.vendor(company_id: '3a502065-2a08-4c3b-9468-fb83642d3d3a').destroy('f0730ada-b315-ea11-a813-000d3ad21e99')
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JDrizzy/business-central.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
