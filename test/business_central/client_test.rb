require "test_helper"
# rake test TEST=test/business_central/client_test.rb

class BusinessCentral::ClientTest < Minitest::Test
  def setup
    @client = BusinessCentral::Client.new
  end

  def test_authorize_client
    test_redirect_url = 'www.example.com'
    response = @client.authorize(oauth_authorize_callback: test_redirect_url)
    assert_match /oauth2\/authorize?/, response
    assert_match /redirect_uri=#{test_redirect_url}/, response
  end

  def test_request_client_token
    test_redirect_url = 'www.example.com'
    test_access_token = '123'

    stub_request(:post, /#{BusinessCentral::Client::DEFAULT_LOGIN_URL}/)
      .to_return(
        status: 200,
        headers: {
          'Content-Type': 'application/json'
        },
        body: {
          access_token: test_access_token,
          refresh_token: '456',
          expires_in: (Time.now + 3600).to_i,
          token_type: 'Bearer'
        }.to_json
      )

    response = @client.request_token('code123', oauth_token_callback: test_redirect_url)
    assert_equal test_access_token,response.token
  end

  def test_authorize_client_from_token
    test_access_token = '123'
    @client.authorize_from_token(
      token: test_access_token,
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    assert_equal test_access_token, @client.access_token.token
  end

  def test_refresh_token
    test_access_token = '789'

    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )

    stub_request(:post, /#{BusinessCentral::Client::DEFAULT_LOGIN_URL}/)
      .to_return(
        status: 200,
        headers: {
          'Content-Type': 'application/json'
        },
        body: {
          access_token: test_access_token,
          refresh_token: '101112',
          expires_in: (Time.now + 3600).to_i,
          token_type: 'Bearer'
        }.to_json
      )

    response = @client.refresh_token
    assert_equal test_access_token, response.token
  end

end