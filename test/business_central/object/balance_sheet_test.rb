# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/balance_sheet_test.rb

class BusinessCentral::Object::BalanceSheetTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @balance_sheet = @client.balance_sheet(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /balanceSheet/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              display: 'balance item 1'
            }
          ]
        }.to_json
      )

    response = @balance_sheet.find_all
    assert_equal response.first[:display], 'balance item 1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /balanceSheet\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          display: 'balance item 2'
        }.to_json
      )

    response = @balance_sheet.find_by_id(test_id)
    assert_equal response[:display], 'balance item 2'
  end

  def test_create
    assert_raises BusinessCentral::NoSupportedMethod do
      @balance_sheet.create({})
    end
  end

  def test_update
    assert_raises BusinessCentral::NoSupportedMethod do
      @balance_sheet.update('123', {})
    end
  end

  def test_delete
    assert_raises BusinessCentral::NoSupportedMethod do
      @balance_sheet.destroy('123')
    end
  end
end
