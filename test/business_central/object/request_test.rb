# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/request_test.rb

class BusinessCentral::Object::RequestTest < Minitest::Test
  def setup
    @url = BusinessCentral::Client::DEFAULT_URL
    @client = BusinessCentral::Client.new
  end

  def test_get_request
    stub_request(:get, @url)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'value1'
            }
          ]
        }.to_json
      )

    response = BusinessCentral::Object::Request.get(@client, @url)

    assert_equal 'value1', response.first[:display_name]
  end

  def test_post_request
    stub_request(:post, @url)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'value2'
            }
          ]
        }.to_json
      )

    response = BusinessCentral::Object::Request.post(@client, @url, display_name: 'value2')

    assert_equal 'value2', response.first[:display_name]
  end

  def test_patch_request
    stub_request(:patch, @url)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'value3'
            }
          ]
        }.to_json
      )

    response = BusinessCentral::Object::Request.patch(@client, @url, '1', display_name: 'value3')

    assert_equal 'value3', response.first[:display_name]
  end

  def test_delete_request
    stub_request(:delete, @url)
      .to_return(status: 204)

    assert BusinessCentral::Object::Request.delete(@client, @url, '1')
  end

  def test_request_convert_symbol_parameters
    param = { new_key: 'value' }
    request = JSON.parse(BusinessCentral::Object::Request.convert(param))
    assert request.key?('newKey')
  end

  def test_skip_request_converting_string_parameters
    param = { 'New_Key' => 'value' }
    request = JSON.parse(BusinessCentral::Object::Request.convert(param))
    assert request.key?('New_Key')
  end

  def test_get_request_returns_unathorized_error
    stub_request(:get, @url)
      .to_return(status: 401)

    assert_raises(BusinessCentral::UnauthorizedException) do
      BusinessCentral::Object::Request.get(@client, @url)
    end
  end

  def test_get_request_returns_error_company_not_found
    stub_request(:get, @url)
      .to_return(
        status: 400,
        body: {
          error: {
            code: 'Internal_CompanyNotFound'
          }
        }.to_json
      )

    assert_raises(BusinessCentral::CompanyNotFoundException) do
      BusinessCentral::Object::Request.get(@client, @url)
    end
  end

  def test_get_request_returns_error_code
    stub_request(:get, @url)
      .to_return(
        status: 400,
        body: {
          error: {
            code: 'Not_Catered_For'
          }
        }.to_json
      )

    assert_raises(BusinessCentral::ApiException) do
      BusinessCentral::Object::Request.get(@client, @url)
    end
  end

  def test_get_request_returns_error_with_no_code
    stub_request(:get, @url)
      .to_return(
        status: 400,
        body: {
          nope: 'wup wup'
        }.to_json
      )

    assert_raises(BusinessCentral::ApiException) do
      BusinessCentral::Object::Request.get(@client, @url)
    end
  end
end
