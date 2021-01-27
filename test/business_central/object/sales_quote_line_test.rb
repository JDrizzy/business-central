# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/sales_quote_line_test.rb

class BusinessCentral::Object::SalesQuoteLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @sales_quote_line = @client.sales_quote_line(
      company_id: @company_id,
      parent: 'salesQuotes',
      parent_id: '123'
    )
  end

  def test_find_all
    stub_request(:get, %r{salesQuotes\(\d+\)\/salesQuoteLines})
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

    response = @sales_quote_line.find_all
    assert_equal response.first[:sequence], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, %r{salesQuotes\(\d+\)\/salesQuoteLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          id: test_id,
          sequence: '1010',
          lineType: 'Comment'
        }.to_json
      )

    response = @sales_quote_line.find_by_id(test_id)
    assert_equal response[:sequence], '1010'
  end

  def test_where
    test_filter = "sequence eq '1020'"
    stub_request(:get, %r{salesQuotes\(\d+\)\/salesQuoteLines\?\$filter=#{test_filter}})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              sequence: '1011'
            }
          ]
        }.to_json
      )

    response = @sales_quote_line.where(test_filter)
    assert_equal response.first[:sequence], '1011'
  end

  def test_create
    stub_request(:post, %r{salesQuotes\(\d+\)\/salesQuoteLines})
      .to_return(
        status: 200,
        body: {
          id: '678',
          sequence: '1012'
        }.to_json
      )

    response = @sales_quote_line.create(
      sequence: '1012'
    )
    assert_equal response[:sequence], '1012'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, %r{salesQuotes\(\d+\)\/salesQuoteLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          sequence: '1012',
          lineType: 'Comment'
        }.to_json
      )

    stub_request(:patch, %r{salesQuotes\(\d+\)\/salesQuoteLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          id: test_id,
          sequence: '1012',
          lineType: 'Account'
        }.to_json
      )

    response = @sales_quote_line.update(
      test_id,
      line_type: 'Account'
    )
    assert_equal response[:line_type], 'Account'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, %r{salesQuotes\(\d+\)\/salesQuoteLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: 7,
          sequence: '1013'
        }.to_json
      )

    stub_request(:delete, %r{salesQuotes\(\d+\)\/salesQuoteLines\(#{test_id}\)})
      .to_return(status: 204)

    assert @sales_quote_line.destroy(test_id)
  end
end
