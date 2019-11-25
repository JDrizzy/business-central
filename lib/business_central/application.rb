module BusinessCentral
  class Application

    DEFAULT_URL = 'https://api.businesscentral.dynamics.com/v1.0/api/beta'.freeze

    attr_reader :client,
                :tenant_id,
                :application_id,
                :secret_key,
                :url

    alias_method :access_token, :client

    def initialize(options = {})
      opts = options.dup
      @tenant_id = opts.delete(:tenant_id)
      @application_id = opts.delete(:application_id)
      @secret_key = opts.delete(:secret_key)
      @url = opts.delete(:url) || DEFAULT_URL
      @client = OAuth2::Client.new(
        @application_id,
        @secret_key,
        {
          site: "https://login.windows.net/#{@tenant_id}",
          authorize_url: 'oauth2/authorize?resource=https://api.businesscentral.dynamics.com',
          token_url: 'oauth2/token?resource=https://api.businesscentral.dynamics.com'
        }
      )
    end

    def authorize(params = {}, oauth_authorize_callback: '')
      params[:redirect_uri] = oauth_authorize_callback
      begin
        @client.auth_code.authorize_url(params)
      rescue Oauth2::Error => error
        handle_error(error)
      end
    end

    def request_token(code = '', oauth_token_callback: '')
      begin
        @client.auth_code.get_token(code, redirect_uri: oauth_token_callback)
      rescue OAuth2::Error => error
        handle_error(error)
      end
    end

    def authorize_from_token(token: '', refresh_token: '', expires_at: nil, expires_in: nil)
      @client = OAuth2::AccessToken.new(
        @client,
        token,
        refresh_token: refresh_token,
        expires_at: expires_at,
        expires_in: expires_in,
      )
    end

    def refresh_token
      @client.refresh!
    end
  end

  private

  def handle_error(error)
    if error.code.present?
      case error.code
        when 'invalid_client'
          raise InvalidClientException.new
      end
    else
      raise ApiException.new(error.message)
    end
  end
end