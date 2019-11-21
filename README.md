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

```Ruby
require 'business_central'

# Create client - used to connect to the API
client = BusinessCentral::Application.new(
    tenant_id: "<tenant_id>",
    application_id: "<application_id>",
    secret_key: "<application_secret_key>",
    url: "<url>"
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/business-central.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
