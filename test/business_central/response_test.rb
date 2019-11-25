require "test_helper"

class BusinessCentral::ResponseTest < Minitest::Test
  def test_process_response
    params = '{"newKey": "value"}'
    request = BusinessCentral::Response.new(params).results
    assert request.has_key?(:new_key)
  end

  def test_success
    assert BusinessCentral::Response.success?(200)
  end

  def test_created_success
    assert BusinessCentral::Response.success?(201)
  end

  def test_unauthorized
    assert BusinessCentral::Response.unauthorized?(401)
  end

  def test_no_response
    BusinessCentral::Response.new("").results
  end
end