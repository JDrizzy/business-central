# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/retained_earning_statement_test.rb

class BusinessCentral::Object::RetainedEarningStatementTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @retained_earning_statement = @client.retained_earning_statement(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /retainedEarningsStatement/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              lineNumber: 20_000,
              display: 'Net Income',
              netChange: 77_770.94,
              lineType: 'detail',
              indentation: 0,
              dateFilter: '2016-12-31'
            }
          ]
        }.to_json
      )

    response = @retained_earning_statement.find_all
    assert_equal response.first[:line_number], 20_000
  end

  def test_create
    assert_raises BusinessCentral::NoSupportedMethod do
      @retained_earning_statement.create({})
    end
  end

  def test_update
    assert_raises BusinessCentral::NoSupportedMethod do
      @retained_earning_statement.update('123', {})
    end
  end

  def test_delete
    assert_raises BusinessCentral::NoSupportedMethod do
      @retained_earning_statement.destroy('123')
    end
  end
end
