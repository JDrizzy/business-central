# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/trial_balance_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::TrialBalanceTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @trial_balance = @client.trial_balance(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /trialBalance/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              number: '1009'
            }
          ]
        }.to_json
      )

    response = @trial_balance.find_all
    assert_equal response.first[:number], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /trialBalance\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1010'
        }.to_json
      )

    response = @trial_balance.find_by_id(test_id)
    assert_equal response[:number], '1010'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /trialBalance\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              number: '1011'
            }
          ]
        }.to_json
      )

    response = @trial_balance.where(test_filter)
    assert_equal response.first[:number], '1011'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @trial_balance.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @trial_balance.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @trial_balance.destroy('123')
    end
  end
end
