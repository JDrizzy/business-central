require "test_helper"

class BusinessCentral::ApplicationTest < Minitest::Test
  def setup
    @application = BusinessCentral::Application.new
  end

  def test_authorize_application
    test_redirect_url = 'www.example.com'
    response = @application.authorize(oauth_authorize_callback: test_redirect_url)
    assert_match /oauth2\/authorize?/, response
    assert_match /redirect_uri=#{test_redirect_url}/, response
  end

  def test_request_application_token
    test_redirect_url = 'www.example.com'
    test_access_token = '123'

    stub_request(:post, /login.windows.net/)
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

    response = @application.request_token('code123', oauth_token_callback: test_redirect_url)
    assert_equal test_access_token,response.token
  end

  def test_authorize_application_from_token
    test_access_token = '123'
    @application.authorize_from_token(
      token: test_access_token,
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    assert_equal test_access_token, @application.access_token.token
  end

  def test_refresh_token
    test_access_token = '789'

    @application.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )

    stub_request(:post, /login.windows.net/)
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

    response = @application.refresh_token
    assert_equal test_access_token, response.token
  end

end