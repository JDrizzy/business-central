# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/response_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::ResponseTest < Minitest::Test
  def setup
    @response = Microsoft::Dynamics365::BusinessCentral::Object::Response
  end

  def test_success
    assert @response.success?(200)
  end

  def test_created_success
    assert @response.success?(201)
  end

  def test_unauthorized
    assert @response.unauthorized?(401)
  end

  def test_no_response
    @response.new('').results
  end

  def test_process_response
    params = '{"newKey": "value"}'
    request = @response.new(params).results
    assert request.key?(:new_key)
  end

  def test_process_etag
    params = '{"@odata.etag": "123"}'
    request = @response.new(params).results
    assert request.key?(:etag)
  end

  def test_process_context
    params = '{"@odata.context": "123"}'
    request = @response.new(params).results
    assert request.key?(:context)
  end

  def test_process_inner_hash
    params = '{"item": { "id": "123" }}'
    request = @response.new(params).results
    assert request.key?(:item)
  end
end
