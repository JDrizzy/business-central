# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/dimension_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::DimensionTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @dimension = @client.dimension(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /dimensions/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '123',
              code: '456',
              displayName: 'Dimension1'
            }
          ]
        }.to_json
      )

    response = @dimension.find_all
    assert_equal response.first[:display_name], 'Dimension1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /dimensions\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: '123',
          code: '456',
          displayName: 'Dimension2'
        }.to_json
      )

    response = @dimension.find_by_id(test_id)
    assert_equal response[:display_name], 'Dimension2'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension.create({})
    end
  end

  def test_update
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension.update('123', {})
    end
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @dimension.destroy('123')
    end
  end
end
