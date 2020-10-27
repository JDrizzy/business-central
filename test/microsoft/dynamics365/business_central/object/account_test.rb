# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/account_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::AccountTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @account = @client.account(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /accounts/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'account1'
            }
          ]
        }.to_json
      )

    response = @account.find_all
    assert_equal response.first[:display_name], 'account1'
  end

  def test_find_by_id
    test_account_id = '123'
    stub_request(:get, /accounts\(#{test_account_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'account2'
        }.to_json
      )

    response = @account.find_by_id(test_account_id)
    assert_equal response[:display_name], 'account2'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @account.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @account.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @account.destroy('123')
    end
  end
end
