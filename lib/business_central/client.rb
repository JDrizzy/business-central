module BusinessCentral
  class Client
    extend BusinessCentral::Object::Helper

    DEFAULT_URL = 'https://api.businesscentral.dynamics.com/v1.0/api/beta'.freeze

    DEFAULT_LOGIN_URL = 'https://login.microsoftonline.com/common'.freeze

    attr_reader :tenant_id,
                :username,
                :password,
                :application_id,
                :secret_key,
                :url,
                :oauth2_login_url,
                :oauth2_client

    alias_method :access_token, :oauth2_client

    object :account
    object :aged_account_payable
    object :aged_account_receivable
    object :balance_sheet
    object :cash_flow_statement
    object :company
    object :company_information
    object :country_region
    object :currency
    object :customer
    object :customer_financial_detail
    object :customer_payment
    object :customer_payment_journal
    object :vendor
    object :purchase_invoice
    object :purchase_invoice_line
    object :item

    def initialize(options = {})
      opts = options.dup
      @tenant_id = opts.delete(:tenant_id)
      @username = opts.delete(:username)
      @password = opts.delete(:password)
      @url = opts.delete(:url) || DEFAULT_URL
      @application_id = opts.delete(:application_id)
      @secret_key = opts.delete(:secret_key)
      @oauth2_login_url = opts.delete(:oauth2_login_url) || DEFAULT_LOGIN_URL
    end

    def authorize(params = {}, oauth_authorize_callback: '')
      params[:redirect_uri] = oauth_authorize_callback
      begin
        oauth2_client.auth_code.authorize_url(params)
      rescue Oauth2::Error => error
        handle_error(error)
      end
    end

    def request_token(code = '', oauth_token_callback: '')
      begin
        oauth2_client.auth_code.get_token(code, redirect_uri: oauth_token_callback)
      rescue OAuth2::Error => error
        handle_error(error)
      end
    end

    def authorize_from_token(token: '', refresh_token: '', expires_at: nil, expires_in: nil)
      @oauth2_client = OAuth2::AccessToken.new(
        oauth2_client,
        token,
        refresh_token: refresh_token,
        expires_at: expires_at,
        expires_in: expires_in,
      )
    end

    def refresh_token
      @oauth2_client.refresh!
    end

    private

    def oauth2_client
      if @oauth2_client.nil?
        @oauth2_client = OAuth2::Client.new(
          @application_id,
          @secret_key,
          {
            site: @oauth2_login_url,
            authorize_url: 'oauth2/authorize?resource=https://api.businesscentral.dynamics.com',
            token_url: 'oauth2/token?resource=https://api.businesscentral.dynamics.com'
          }
        )
      end
        
      return @oauth2_client
    end

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
end