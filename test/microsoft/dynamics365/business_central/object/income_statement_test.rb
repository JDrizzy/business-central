# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/income_statement_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::IncomeStatementTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @income_statement = @client.income_statement(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /incomeStatement/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              lineNumber: '1009'
            }
          ]
        }.to_json
      )

    response = @income_statement.find_all
    assert_equal response.first[:line_number], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /incomeStatement\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          lineNumber: '1010'
        }.to_json
      )

    response = @income_statement.find_by_id(test_id)
    assert_equal response[:line_number], '1010'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /incomeStatement\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              lineNumber: '1011'
            }
          ]
        }.to_json
      )

    response = @income_statement.where(test_filter)
    assert_equal response.first[:line_number], '1011'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @income_statement.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @income_statement.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @income_statement.destroy('123')
    end
  end
end
