# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/response_test.rb

class BusinessCentral::Object::ResponseTest < Minitest::Test
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
    BusinessCentral::Object::Response.new('').results
  end

  def test_process_response
    params = '{"newKey": "value"}'
    request = BusinessCentral::Object::Response.new(params).results
    assert request.key?(:new_key)
  end

  def test_process_etag
    params = '{"@odata.etag": "123"}'
    request = BusinessCentral::Object::Response.new(params).results
    assert request.key?(:etag)
  end

  def test_process_context
    params = '{"@odata.context": "123"}'
    request = BusinessCentral::Object::Response.new(params).results
    assert request.key?(:context)
  end

  def test_process_inner_hash
    params = '{"item": { "id": "123" }}'
    request = BusinessCentral::Object::Response.new(params).results
    assert request.key?(:item)
  end

  def test_string_response
    response = BusinessCentral::Object::Response.new('{ "value": "OK - Action was successful" }')
    assert_equal 'OK - Action was successful', response.results
  end
end
