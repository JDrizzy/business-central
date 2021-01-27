# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/customer_test.rb

class BusinessCentral::Object::CustomerTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @customer = @client.customer(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /customers/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              displayName: 'customer1'
            }
          ]
        }.to_json
      )

    response = @customer.find_all
    assert_equal response.first[:display_name], 'customer1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /customers\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          displayName: 'customer2'
        }.to_json
      )

    response = @customer.find_by_id(test_id)
    assert_equal response[:display_name], 'customer2'
  end

  def test_where
    test_filter = "displayName eq 'customer3'"
    stub_request(:get, /customers\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              displayName: 'customer3'
            }
          ]
        }.to_json
      )

    response = @customer.where(test_filter)
    assert_equal response.first[:display_name], 'customer3'
  end

  def test_create
    stub_request(:post, /customers/)
      .to_return(
        status: 200,
        body: {
          displayName: 'customer4'
        }.to_json
      )

    response = @customer.create(
      display_name: 'customer4'
    )
    assert_equal response[:display_name], 'customer4'
  end

  def test_update
    test_id = '2'
    stub_request(:get, /customers\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          id: test_id,
          displayName: 'customer5'
        }.to_json
      )

    stub_request(:patch, /customers\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '4444',
          displayName: 'customer6'
        }.to_json
      )

    response = @customer.update(
      test_id,
      display_name: 'customer6'
    )
    assert_equal response[:display_name], 'customer6'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /customers\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          displayName: 'customer7'
        }.to_json
      )

    stub_request(:delete, /customers\(#{test_id}\)/)
      .to_return(status: 204)

    assert @customer.destroy(test_id)
  end

  def test_default_dimension_navigation
    stub_request(:get, %r{customers\(\d+\)\/defaultDimensions})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              parentId: '123',
              dimensionId: '123',
              dimensionCode: 'ABC',
              dimensionValueId: 1,
              dimensionValueCode: 'DEF'
            }
          ]
        }.to_json
      )

    response = @client.customer(company_id: @company_id, id: '123')
                      .default_dimension.find_all
    assert_equal response.first[:parent_id], '123'
  end

  def test_picture_navigation
    stub_request(:get, %r{customers\(\d+\)\/picture})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              width: 500,
              height: 496,
              contentType: 'image\jpeg'
            }
          ]
        }.to_json
      )

    response = @client.customer(company_id: @company_id, id: '123')
                      .picture.find_all
    assert_equal response.first[:width], 500
  end
end
