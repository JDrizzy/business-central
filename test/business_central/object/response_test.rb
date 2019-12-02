require "test_helper"
# rake test TEST=test/business_central/object/response_test.rb

class BusinessCentral::Object::ResponseTest < Minitest::Test
  def test_process_response
    params = '{"newKey": "value"}'
    request = BusinessCentral::Object::Response.new(params).results
    assert request.has_key?(:new_key)
  end

  def test_success
    assert BusinessCentral::Object::Response.success?(200)
  end

  def test_created_success
    assert BusinessCentral::Object::Response.success?(201)
  end

  def test_unauthorized
    assert BusinessCentral::Object::Response.unauthorized?(401)
  end

  def test_no_response
    BusinessCentral::Object::Response.new("").results
  end
end