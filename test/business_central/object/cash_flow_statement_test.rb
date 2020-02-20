# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/cash_flow_statement_test.rb

class BusinessCentral::Object::CashFlowStatementTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @cash_flow_statement = @client.cash_flow_statement(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /cashFlowStatement/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              display: 'assets 1'
            }
          ]
        }.to_json
      )

    response = @cash_flow_statement.find_all
    assert_equal response.first[:display], 'assets 1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /cashFlowStatement\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          display: 'assets 2'
        }.to_json
      )

    response = @cash_flow_statement.find_by_id(test_id)
    assert_equal response[:display], 'assets 2'
  end

  def test_create
    assert_raises BusinessCentral::NoSupportedMethod do
      @cash_flow_statement.create({})
    end
  end

  def test_update
    assert_raises BusinessCentral::NoSupportedMethod do
      @cash_flow_statement.update('123', {})
    end
  end

  def test_delete
    assert_raises BusinessCentral::NoSupportedMethod do
      @cash_flow_statement.destroy('123')
    end
  end
end
