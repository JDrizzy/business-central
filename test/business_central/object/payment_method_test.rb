# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/payment_method_test.rb

class BusinessCentral::Object::PaymentMethodTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @payment_method = @client.payment_method(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /paymentMethods/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              code: 'PM1',
              displayName: 'paymentMethod1'
            }
          ]
        }.to_json
      )

    response = @payment_method.find_all
    assert_equal response.first[:display_name], 'paymentMethod1'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /paymentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: 'PM2',
          displayName: 'paymentMethod2'
        }.to_json
      )

    response = @payment_method.find_by_id(test_id)
    assert_equal response[:display_name], 'paymentMethod2'
  end

  def test_where
    test_filter = "displayName eq 'paymentMethod3'"
    stub_request(:get, /paymentMethods\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              code: 'PM3',
              displayName: 'paymentMethod3'
            }
          ]
        }.to_json
      )

    response = @payment_method.where(test_filter)
    assert_equal response.first[:display_name], 'paymentMethod3'
  end

  def test_create
    stub_request(:post, /paymentMethods/)
      .to_return(
        status: 200,
        body: {
          id: 4,
          code: 'PM4',
          displayName: 'paymentMethod4'
        }.to_json
      )

    response = @payment_method.create(
      code: 'PM4',
      display_name: 'paymentMethod4'
    )
    assert_equal response[:display_name], 'paymentMethod4'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /paymentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          code: 'PM5',
          displayName: 'paymentMethod5'
        }.to_json
      )

    stub_request(:patch, /paymentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: 'PM6',
          displayName: 'paymentMethod6'
        }.to_json
      )

    response = @payment_method.update(
      test_id,
      code: 'PM6',
      display_name: 'paymentMethod6'
    )
    assert_equal response[:display_name], 'paymentMethod6'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /paymentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          code: 'PM7',
          displayName: 'paymentMethod7'
        }.to_json
      )

    stub_request(:delete, /paymentMethods\(#{test_id}\)/)
      .to_return(status: 204)

    assert @payment_method.destroy(test_id)
  end
end
