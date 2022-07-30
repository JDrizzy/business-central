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

This gem supports both basic and OAuth2 authentication methods:

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/api-reference/v2.0/endpoints-apis-for-dynamics

```Ruby
require 'business_central'

client = BusinessCentral::Client.new(
    username: '<username>',                 # Basic authentication username
    password: '<password>',                 # Basic authentication password
    url: '<url>',                           # URL for API defaults to https://api.businesscentral.dynamics.com/v2.0/production/api/v1.0
    web_service_url: '<url>',               # URL for custom web services defaults to https://api.businesscentral.dynamics.com/v2.0/production/ODataV4 
    application_id: '<application_id>',     # Oauth2 authentication application ID
    secret_key: '<application_secret_key>', # OAuth2 authentication application secret key
    oauth2_login_url: '<url>',              # OAuth2 authentication login URL defaults to https://login.microsoftonline.com/common
    default_company_id: '<company_id>',     # Default company ID used in all requests (if required)
    debug: false                            # Output requests to console
)
```

### Basic Authentication:

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-connect-apps#setting-up-basic-authentication

```Ruby
require 'business_central'

client = BusinessCentral::Client.new(
    username: '<username>',
    password: '<password>',
    url: '<url>',
    default_company_id: '11111111-2222-3333-4444-555555555555'
)
```

### Oauth2 Authentication

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-connect-apps#AAD

```Ruby
require 'business_central'

# Create client - used to connect to the API
client = BusinessCentral::Client.new(
    application_id: '<application_id>',
    secret_key: '<application_secret_key>',
    url: '<url>',
    default_company_id: '11111111-2222-3333-4444-555555555555'
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
```

### Calling objects

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/api-reference/v2.0/

```Ruby
begin
    # Find all vendors
    client.vendors.all

    # Find vendor by ID
    client.vendors.find('557d12d7-25f5-ec11-82f1-000d3a299c8c')

    # Query vendor by display name
    client.vendors.where("displayName eq 'First Up Consultants'")

    # Create a new vendor
    client.vendors.create({ display_name: 'hello testing' })

    # Update an existing vendor by ID
    client.vendors.update('39a7ef39-ba0f-ed11-90ed-00224895e26b', { phone_number: '1112' })

    # Delete a vendor
    client.vendors.destroy('39a7ef39-ba0f-ed11-90ed-00224895e26b')

    # ---------

    # Find all vendor default dimensions
    client.vendors(id: '557d12d7-25f5-ec11-82f1-000d3a299c8c').default_dimensions.all

    # Query vendor default dimensions by dimension code
    client.vendors(id: '557d12d7-25f5-ec11-82f1-000d3a299c8c').default_dimensions.where("dimensionCode eq 'DEPARTMENT'")

    # Create a new vendor default dimension
    client.vendors(id: '557d12d7-25f5-ec11-82f1-000d3a299c8c').default_dimensions.create({ dimension_code: 'DEPARTMENT' })

    # Update an existing vendor default dimension
    client.vendors(id: '557d12d7-25f5-ec11-82f1-000d3a299c8c').default_dimensions.update('6576ecf4-25f5-ec11-82f1-000d3a299c8c', { dimension_code: 'NEW_DEPARTMENT' })

    # Delete a vendor default dimension
    client.vendors(id: '557d12d7-25f5-ec11-82f1-000d3a299c8c').default_dimensions.destroy('6576ecf4-25f5-ec11-82f1-000d3a299c8c')
rescue StandardError => e
  puts e.message
rescue BusinessCentral::ApiException => e
  puts e.message
end
```

All objects should be callable, assuming the endpoint exists.

### OData Web Services

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/webservices/odata-web-services

```Ruby
require 'business_central'

client = BusinessCentral::Client.new(
    username: '<username>',
    password: '<password>',
    web_service_url: '<url>'
)

# Query a record 
company = client.web_service.object("Company('?')/Purchase_Order", 'My Company').get

# Create a record
client.web_service.object("Company('?')/Purchase_Order", 'My Company').post({})

# Update a record
client.web_service.object("Company('?')/Purchase_Order", 'My Company').patch({})

# Delete a record
client.web_service.object("Company('?')/Purchase_Order", 'My Company').delete
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JDrizzy/business-central.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
