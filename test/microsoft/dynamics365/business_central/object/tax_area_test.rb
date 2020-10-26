# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/tax_area_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::TaxAreaTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @tax_area = @client.tax_area(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /taxAreas/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              number: '1009'
            }
          ]
        }.to_json
      )

    response = @tax_area.find_all
    assert_equal response.first[:number], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /taxAreas\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1010'
        }.to_json
      )

    response = @tax_area.find_by_id(test_id)
    assert_equal response[:number], '1010'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /taxAreas\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              number: '1011'
            }
          ]
        }.to_json
      )

    response = @tax_area.where(test_filter)
    assert_equal response.first[:number], '1011'
  end

  def test_create
    stub_request(:post, /taxAreas/)
      .to_return(
        status: 200,
        body: {
          id: '678',
          number: '1012'
        }.to_json
      )

    response = @tax_area.create(
      number: '1012'
    )
    assert_equal response[:number], '1012'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /taxAreas\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          number: '1012'
        }.to_json
      )

    stub_request(:patch, /taxAreas\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1013'
        }.to_json
      )

    response = @tax_area.update(
      test_id,
      number: '1013'
    )
    assert_equal response[:number], '1013'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /taxAreas\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: test_id,
          number: '1013'
        }.to_json
      )

    stub_request(:delete, /taxAreas\(#{test_id}\)/)
      .to_return(status: 204)

    assert @tax_area.destroy(test_id)
  end
end
