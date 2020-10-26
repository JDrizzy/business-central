# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/dimension_line_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::DimensionLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @dimension_line = @client.dimension_line(
      company_id: @company_id
    )
  end

  def test_find_all
    stub_request(:get, /dimensionLines/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              parent_id: 1,
              id: '123',
              code: '456',
              displayName: 'dimension line 1',
              valueId: 1,
              valueCode: 'ABC',
              valueDisplayName: 'DEF'
            }
          ]
        }.to_json
      )

    response = @dimension_line.find_all
    assert_equal response.first[:display_name], 'dimension line 1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /dimensionLines\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          parent_id: 2,
          id: test_id,
          code: '789',
          displayName: 'dimension line 2',
          valueId: 2,
          valueCode: 'DEF',
          valueDisplayName: 'GHI'
        }.to_json
      )

    response = @dimension_line.find_by_id(test_id)
    assert_equal response[:display_name], 'dimension line 2'
  end

  def test_where
    test_filter = "displayName eq 'dimension line 3'"
    stub_request(:get, /dimensionLines\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              parent_id: 3,
              id: '456',
              code: '789',
              displayName: 'dimension line 3',
              valueId: 3,
              valueCode: 'GHI',
              valueDisplayName: 'JKL'
            }
          ]
        }.to_json
      )

    response = @dimension_line.where(test_filter)
    assert_equal response.first[:display_name], 'dimension line 3'
  end

  def test_create
    stub_request(:post, /dimensionLines/)
      .to_return(
        status: 200,
        body: {
          parent_id: 4,
          code: '1011',
          displayName: 'dimension line 4',
          valueId: 4,
          valueCode: 'MNO',
          valueDisplayName: 'PQR'
        }.to_json
      )

    response = @dimension_line.create(
      parent_id: 4,
      value_id: 4
    )
    assert_equal response[:parent_id], 4
  end

  def test_update
    test_id = '2'
    stub_request(:get, /dimensionLines\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '1111',
          parent_id: 5,
          id: 5,
          code: '1011',
          displayName: 'dimension line 4',
          valueId: 4,
          valueCode: 'MNO',
          valueDisplayName: 'PQR'
        }.to_json
      )

    stub_request(:patch, /dimensionLines\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '2222',
          parent_id: 5,
          id: 5,
          code: '1011',
          displayName: 'dimension line 5',
          valueId: 5,
          valueCode: 'MNO',
          valueDisplayName: 'PQR'
        }.to_json
      )

    response = @dimension_line.update(
      test_id,
      display_name: 'dimension line 5',
      value_id: 5
    )
    assert_equal response[:display_name], 'dimension line 5'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /dimensionLines\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          parent_id: 6,
          id: '33333',
          code: '1011',
          displayName: 'dimension line 6',
          valueId: 6,
          valueCode: 'MNO',
          valueDisplayName: 'PQR'
        }.to_json
      )

    stub_request(:delete, /dimensionLines\(#{test_id}\)/)
      .to_return(status: 204)

    assert @dimension_line.destroy(test_id)
  end
end
