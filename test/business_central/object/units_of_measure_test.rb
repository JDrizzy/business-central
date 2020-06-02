# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/units_of_measure_test.rb

class BusinessCentral::Object::UnitsOfMeasureTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @units_of_measure = @client.units_of_measure(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /unitsOfMeasure/)
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

    response = @units_of_measure.find_all
    assert_equal response.first[:number], '1009'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /unitsOfMeasure\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1010'
        }.to_json
      )

    response = @units_of_measure.find_by_id(test_id)
    assert_equal response[:number], '1010'
  end

  def test_where
    test_filter = "number eq '1020'"
    stub_request(:get, /unitsOfMeasure\?\$filter=#{test_filter}/)
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

    response = @units_of_measure.where(test_filter)
    assert_equal response.first[:number], '1011'
  end

  def test_create
    stub_request(:post, /unitsOfMeasure/)
      .to_return(
        status: 200,
        body: {
          id: '678',
          number: '1012'
        }.to_json
      )

    response = @units_of_measure.create(
      number: '1012'
    )
    assert_equal response[:number], '1012'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /unitsOfMeasure\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          number: '1012'
        }.to_json
      )

    stub_request(:patch, /unitsOfMeasure\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: '1013'
        }.to_json
      )

    response = @units_of_measure.update(
      test_id,
      number: '1013'
    )
    assert_equal response[:number], '1013'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /unitsOfMeasure\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: test_id,
          number: '1013'
        }.to_json
      )

    stub_request(:delete, /unitsOfMeasure\(#{test_id}\)/)
      .to_return(status: 204)

    assert @units_of_measure.destroy(test_id)
  end
end
