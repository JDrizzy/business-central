# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/companies_test.rb

class BusinessCentral::Object::CompaniesTest < Minitest::Test
  def setup
    @client = BusinessCentral::Client.new
    @company = @client.companies
  end

  def test_find_all
    stub_request(:get, /companies/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'business1'
            }
          ]
        }.to_json
      )

    response = @company.find_all
    assert_equal response.first[:display_name], 'business1'
  end

  def test_find_by_id
    test_company_id = '123'
    stub_request(:get, /companies\(#{test_company_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'business2'
        }.to_json
      )

    response = @company.find_by_id(test_company_id)
    assert_equal response[:display_name], 'business2'
  end
end
