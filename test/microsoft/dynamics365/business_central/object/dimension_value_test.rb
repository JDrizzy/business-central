# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/dimension_value_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::DimensionValueTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @dimension_value = @client.dimension_value(
      company_id: @company_id,
      dimension_id: '123456'
    )
  end

  def test_find_all
    stub_request(:get, /dimensionValues/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '123',
              code: '456',
              displayName: 'dimension value 1'
            }
          ]
        }.to_json
      )

    response = @dimension_value.find_all
    assert_equal response.first[:display_name], 'dimension value 1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /dimensionValues\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: '123',
          code: '456',
          displayName: 'dimension value 2'
        }.to_json
      )

    response = @dimension_value.find_by_id(test_id)
    assert_equal response[:display_name], 'dimension value 2'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension_value.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension_value.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension_value.destroy('123')
    end
  end
end
