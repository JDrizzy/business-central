# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/shipment_method_test.rb

class BusinessCentral::Object::ShipmentMethodTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @shipment_method = @client.shipment_method(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /shipmentMethods/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              code: '1001',
              displayName: 'shippingMethod1'
            }
          ]
        }.to_json
      )

    response = @shipment_method.find_all
    assert_equal response.first[:display_name], 'shippingMethod1'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /shipmentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: '1002',
          displayName: 'shippingMethod2'
        }.to_json
      )

    response = @shipment_method.find_by_id(test_id)
    assert_equal response[:display_name], 'shippingMethod2'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /shipmentMethods\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              code: '1003',
              displayName: 'shippingMethod3'
            }
          ]
        }.to_json
      )

    response = @shipment_method.where(test_filter)
    assert_equal response.first[:display_name], 'shippingMethod3'
  end

  def test_create
    stub_request(:post, /shipmentMethods/)
      .to_return(
        status: 200,
        body: {
          id: '678',
          code: '1003',
          displayName: 'shippingMethod3'
        }.to_json
      )

    response = @shipment_method.create(
      display_name: 'shippingMethod3'
    )
    assert_equal response[:display_name], 'shippingMethod3'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /shipmentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          code: '1004',
          displayName: 'shippingMethod4'
        }.to_json
      )

    stub_request(:patch, /shipmentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: '1004',
          displayName: 'shippingMethod4_1'
        }.to_json
      )

    response = @shipment_method.update(
      test_id,
      display_name: 'shippingMethod4_1'
    )
    assert_equal response[:display_name], 'shippingMethod4_1'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /shipmentMethods\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: test_id,
          code: '1005',
          displayName: 'shippingMethod5'
        }.to_json
      )

    stub_request(:delete, /shipmentMethods\(#{test_id}\)/)
      .to_return(status: 204)

    assert @shipment_method.destroy(test_id)
  end
end
