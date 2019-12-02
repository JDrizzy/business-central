require "test_helper"
# rake test TEST=test/business_central/object/request_test.rb

class BusinessCentral::Object::RequestTest < Minitest::Test
  def setup
    @client = BusinessCentral::Client.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
  end

  def test_get_build_request
    stub_request(:get, BusinessCentral::Client::DEFAULT_URL)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'value1'
            }
          ]
        }.to_json,
      )

    response = BusinessCentral::Object::Request.build do
      @client.access_token.get(
        BusinessCentral::Client::DEFAULT_URL,
        params: {},
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      )
    end

    assert 'value1', response.first[:display_name]
  end

  def test_post_build_request
    stub_request(:post, BusinessCentral::Client::DEFAULT_URL)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'value2'
            }
          ]
        }.to_json,
      )

    response = BusinessCentral::Object::Request.build do
      @client.access_token.post(
        BusinessCentral::Client::DEFAULT_URL,
        body: {},
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      )
    end

    assert 'value2', response.first[:display_name]
  end

  def test_request_convert_parameters
    param = { new_key: 'value' }
    request = JSON.parse(BusinessCentral::Object::Request.convert(param))
    assert request.has_key?("newKey")
  end
end