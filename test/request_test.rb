require "test_helper"

class RequestTest < Minitest::Test
  def setup
    @client = BusinessCentral::Application.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
  end

  def test_get_build_request
    stub_request(:get, BusinessCentral::Application::DEFAULT_URL)
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

    response = BusinessCentral::Request.build do
      @client.access_token.get(
        BusinessCentral::Application::DEFAULT_URL,
        params: {},
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      )
    end

    assert response.first.has_key?(:display_name)
    assert 'value1', response.first[:display_name]
  end

  def test_post_build_request
    stub_request(:post, BusinessCentral::Application::DEFAULT_URL)
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

    response = BusinessCentral::Request.build do
      @client.access_token.post(
        BusinessCentral::Application::DEFAULT_URL,
        body: {},
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      )
    end

    assert response.first.has_key?(:display_name)
    assert 'value2', response.first[:display_name]
  end

  def test_request_convert_parameters
    param = { new_key: 'value' }
    request = JSON.parse(BusinessCentral::Request.convert(param))
    assert request.has_key?("newKey")
  end
end