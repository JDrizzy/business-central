require "test_helper"
# rake test TEST=test/business_central/object/default_dimension_test.rb

class BusinessCentral::Object::DefaultDimensionTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @default_dimension = @client.default_dimension(
      company_id: @company_id,
      parent: 'vendors',
      parent_id: '123'
    )
  end

  def test_invalid_default_dimension_parent
    assert_raises(BusinessCentral::InvalidArgumentException) do
      @client.default_dimension(
        company_id: @company_id,
        parent: 'something that doesnt exist',
        parent_id: '1'
      )
    end
  end

  def test_find_all
    stub_request(:get, /defaultDimensions/)
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
        }.to_json,
      )

    response = @default_dimension.find_all
    assert_equal response.first[:parent_id], '123'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /defaultDimensions\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          id: test_id,
          parentId: '123',
          dimensionId: '123',
          dimensionCode: 'ABC',
          dimensionValueId: 1,
          dimensionValueCode: 'DEF'
        }.to_json
      )

    response = @default_dimension.find_by_id(test_id)
    assert_equal response[:dimension_code], 'ABC'
  end

  def test_where
    test_filter = "dimensionCode eq 'ABC'"
    stub_request(:get, /defaultDimensions\?\$filter=#{test_filter}/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              id: 3,
              parentId: '123',
              dimensionId: '123',
              dimensionCode: 'ABC',
              dimensionValueId: 1,
              dimensionValueCode: 'DEF'
            }
          ]
        }.to_json
      )

    response = @default_dimension.where(test_filter)
    assert_equal response.first[:dimension_code], 'ABC'
  end

  def test_create
    stub_request(:post, /defaultDimensions/)
      .to_return(
        status: 200, 
        body: {
          id: 4,
          parentId: '123',
          dimensionId: '123',
          dimensionCode: 'ABC',
          dimensionValueId: 1,
          dimensionValueCode: 'DEF'
        }.to_json
      )

    response = @default_dimension.create({
      dimension_code: 'DEF',
      dimension_value_code: 'GHI'
    })
    assert_equal response[:id], 4
  end


  def test_update
    test_id = '2'
    stub_request(:get, /defaultDimensions\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '3333',
          id: test_id,
          parentId: '123',
          dimensionId: '123',
          dimensionCode: 'ABC',
          dimensionValueId: 1,
          dimensionValueCode: 'DEF'
        }.to_json
      )

    stub_request(:patch, /defaultDimensions\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '4444',
          id: test_id,
          parentId: '123',
          dimensionId: '123',
          dimensionCode: 'ZYX',
          dimensionValueId: 1,
          dimensionValueCode: 'DEF'
        }.to_json
      )

    response = @default_dimension.update(
      test_id,
      {
        dimension_code: 'ZYX'
      }
    )
    assert_equal response[:dimension_code], 'ZYX'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /defaultDimensions\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '5555',
          id: test_id,
          parentId: '123',
          dimensionId: '123',
          dimensionCode: 'ZYX',
          dimensionValueId: 1,
          dimensionValueCode: 'DEF'
        }.to_json
      )

    stub_request(:delete, /defaultDimensions\(#{test_id}\)/)
      .to_return(status: 204)

    assert @default_dimension.destroy(test_id)
  end
end