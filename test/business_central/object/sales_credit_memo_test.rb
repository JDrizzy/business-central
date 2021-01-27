# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/sales_credit_memo_test.rb

class BusinessCentral::Object::SalesCreditMemoTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @sales_credit_memo = @client.sales_credit_memo(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /salesCreditMemos/)
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

    response = @sales_credit_memo.find_all
    assert_equal response.first[:number], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /salesCreditMemos\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1010'
        }.to_json
      )

    response = @sales_credit_memo.find_by_id(test_id)
    assert_equal response[:number], '1010'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /salesCreditMemos\?\$filter=#{test_filter}/)
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

    response = @sales_credit_memo.where(test_filter)
    assert_equal response.first[:number], '1011'
  end

  def test_create
    stub_request(:post, /salesCreditMemos/)
      .to_return(
        status: 200,
        body: {
          id: '678',
          number: '1012'
        }.to_json
      )

    response = @sales_credit_memo.create(
      number: '1012'
    )
    assert_equal response[:number], '1012'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /salesCreditMemos\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          number: '1012'
        }.to_json
      )

    stub_request(:patch, /salesCreditMemos\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1013'
        }.to_json
      )

    response = @sales_credit_memo.update(
      test_id,
      number: '1013'
    )
    assert_equal response[:number], '1013'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /salesCreditMemos\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: 7,
          number: '1013'
        }.to_json
      )

    stub_request(:delete, /salesCreditMemos\(#{test_id}\)/)
      .to_return(status: 204)

    assert @sales_credit_memo.destroy(test_id)
  end

  def test_line_navigation
    stub_request(:get, %r{salesCreditMemos\(\d+\)\/salesCreditMemoLine})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              sequence: '1009',
              lineType: 'Comment'
            }
          ]
        }.to_json
      )

    response = @client.sales_credit_memo(company_id: @company_id, id: '123')
                      .sales_credit_memo_line.find_all
    assert_equal response.first[:sequence], '1009'
  end
end
