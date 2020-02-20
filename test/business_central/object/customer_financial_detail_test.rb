# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/customer_financial_detail_test.rb

class BusinessCentral::Object::CustomerFinancialDetailTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @customer_financial_detail = @client.customer_financial_detail(
      company_id: @company_id
    )
  end

  def test_find_all
    stub_request(:get, /customerFinancialDetails/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              number: 'N1',
              balance: 0
            }
          ]
        }.to_json
      )

    response = @customer_financial_detail.find_all
    assert_equal response.first[:number], 'N1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /customerFinancialDetails\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: 'N2',
          balance: 0
        }.to_json
      )

    response = @customer_financial_detail.find_by_id(test_id)
    assert_equal response[:number], 'N2'
  end

  def test_where
    test_filter = "number eq 'N3'"
    stub_request(:get, /customerFinancialDetails\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              number: 'N3'
            }
          ]
        }.to_json
      )

    response = @customer_financial_detail.where(test_filter)
    assert_equal response.first[:number], 'N3'
  end
end
