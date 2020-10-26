# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'business-central'

require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/mock'
require 'minitest/reporters'

require 'byebug'
require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)

Minitest::Reporters.use!
