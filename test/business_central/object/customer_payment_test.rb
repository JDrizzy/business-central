# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/customer_payment_test.rb

class BusinessCentral::Object::CustomerPaymentTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @customer_payment = @client.customer_payment(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /customerPayments/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              lineNumber: 1,
              customerId: 1,
              customerNumber: '123'
            }
          ]
        }.to_json
      )

    response = @customer_payment.find_all
    assert_equal response.first[:customer_number], '123'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /customerPayments\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          lineNumber: 1,
          customerId: test_id,
          customerNumber: '456'
        }.to_json
      )

    response = @customer_payment.find_by_id(test_id)
    assert_equal response[:customer_number], '456'
  end

  def test_where
    test_filter = "customerNumber eq '123'"
    stub_request(:get, /customerPayments\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              lineNumber: 1,
              customerId: 1,
              customerNumber: '123'
            }
          ]
        }.to_json
      )

    response = @customer_payment.where(test_filter)
    assert_equal response.first[:customer_number], '123'
  end

  def test_create
    stub_request(:post, /customerPayments/)
      .to_return(
        status: 200,
        body: {
          id: 1,
          lineNumber: 1,
          customerId: 1,
          customerNumber: '789'
        }.to_json
      )

    response = @customer_payment.create(
      customer_number: '789'
    )
    assert_equal response[:customer_number], '789'
  end

  def test_update
    test_id = '2'
    stub_request(:get, /customerPayments\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          id: test_id,
          lineNumber: 1,
          customerId: 1,
          customerNumber: '789'
        }.to_json
      )

    stub_request(:patch, /customerPayments\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '4444',
          id: test_id,
          lineNumber: 1,
          customerId: 1,
          customerNumber: '1011'
        }.to_json
      )

    response = @customer_payment.update(
      test_id,
      customer_number: '1011'
    )
    assert_equal response[:customer_number], '1011'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /customerPayments\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          id: test_id,
          lineNumber: 1,
          customerId: 1,
          customerNumber: '1213'
        }.to_json
      )

    stub_request(:delete, /customerPayments\(#{test_id}\)/)
      .to_return(status: 204)

    assert @customer_payment.destroy(test_id)
  end
end
