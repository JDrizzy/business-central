require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "business_central"

require "minitest/autorun"
require "minitest/mock"

require "byebug"
require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)