# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/base_test.rb

class BusinessCentral::Object::BaseTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new(
      default_company_id: @company_id
    )
  end

  def test_client_responds_to_any_method_object
    assert(@client.respond_to?(:random_object_that_does_not_exist))
  end

  def test_respond_to_chaining_objects
    assert(@client.vendors.respond_to?(:random_object_that_does_not_exist))
  end

  def test_find_all_for_vendor_object
    stub_request(:get, %r{companies\(#{@company_id}\)/vendors})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'vendor1'
            }
          ]
        }.to_json
      )

    response = @client.vendors.find_all
    assert_equal response.first[:display_name], 'vendor1'
  end

  def test_find_all_for_vendors_default_dimensions
    stub_request(:get, %r{companies\(#{@company_id}\)/vendors\(1\)/defaultDimensions})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              dimensionValueCode: 'SALES'
            }
          ]
        }.to_json
      )

    response = @client.vendors(id: 1).default_dimensions.find_all
    assert_equal response.first[:dimension_value_code], 'SALES'
  end

  def test_update_vendor_object
    test_id = 1
    stub_request(:get, %r{companies\(#{@company_id}\)/vendors\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '111',
          displayName: 'vendor1'
        }.to_json
      )

    stub_request(:patch, %r{companies\(#{@company_id}\)/vendors\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          displayName: 'vendor2'
        }.to_json
      )

    response = @client.vendors.update(test_id, { display_name: 'vendor2' })
    assert_equal response[:display_name], 'vendor2'
  end
end
