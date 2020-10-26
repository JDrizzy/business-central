# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/aged_account_receivable_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::AgedAccountReceivableTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @aged_account_receivable = @client.aged_account_receivable(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /agedAccountsReceivable/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              name: 'customer1'
            }
          ]
        }.to_json
      )

    response = @aged_account_receivable.find_all
    assert_equal response.first[:name], 'customer1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /agedAccountsReceivable\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          name: 'customer2'
        }.to_json
      )

    response = @aged_account_receivable.find_by_id(test_id)
    assert_equal response[:name], 'customer2'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @aged_account_receivable.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @aged_account_receivable.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @aged_account_receivable.destroy('123')
    end
  end
end
