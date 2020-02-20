# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/country_region_test.rb

class BusinessCentral::Object::CountryRegionTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @country_region = @client.country_region(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /countriesRegions/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              code: 'C1',
              displayName: 'country1'
            }
          ]
        }.to_json
      )

    response = @country_region.find_all
    assert_equal response.first[:display_name], 'country1'
  end

  def test_find_by_id
    test_id = '1111'
    stub_request(:get, /countriesRegions\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: 2,
          code: 'C2',
          displayName: 'country2'
        }.to_json
      )

    response = @country_region.find_by_id(test_id)
    assert_equal response[:display_name], 'country2'
  end

  def test_where
    test_filter = "displayName eq 'country3'"
    stub_request(:get, /countriesRegions\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'country3'
            }
          ]
        }.to_json
      )

    response = @country_region.where(test_filter)
    assert_equal response.first[:display_name], 'country3'
  end

  def test_create
    stub_request(:post, /countriesRegions/)
      .to_return(
        status: 200,
        body: {
          displayName: 'country4'
        }.to_json
      )

    response = @country_region.create(
      code: 'C4',
      display_name: 'country4'
    )
    assert_equal response[:display_name], 'country4'
  end

  def test_update
    test_id = '22222'
    stub_request(:get, /countriesRegions\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '2222',
          code: 'C5',
          displayName: 'country5'
        }.to_json
      )

    stub_request(:patch, /countriesRegions\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '2222',
          code: 'C6',
          displayName: 'country6'
        }.to_json
      )

    response = @country_region.update(
      test_id,
      code: 'C6',
      display_name: 'country6'
    )
    assert_equal response[:display_name], 'country6'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /countriesRegions\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          code: 'C7',
          displayName: 'country7'
        }.to_json
      )

    stub_request(:delete, /countriesRegions\(#{test_id}\)/)
      .to_return(status: 204)

    assert @country_region.destroy(test_id)
  end
end
