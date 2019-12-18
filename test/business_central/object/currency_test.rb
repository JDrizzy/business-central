require "test_helper"
# rake test TEST=test/business_central/object/currency_test.rb

class BusinessCentral::Object::CurrencyTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @currency = @client.currency(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /currencies/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              id: 1,
              code: 'C1',
              displayName: 'currency1',
              symbol: '$',
              amountDecimalPlaces: '2:2',
              amountRoundingPrecision: 0.01
            }
          ]
        }.to_json,
      )

    response = @currency.find_all
    assert_equal response.first[:display_name], 'currency1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /currencies\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          id: test_id,
          code: 'C2',
          displayName: 'currency2',
          symbol: '$',
          amountDecimalPlaces: '2:2',
          amountRoundingPrecision: 0.01
        }.to_json
      )

    response = @currency.find_by_id(test_id)
    assert_equal response[:display_name], 'currency2'
  end

  def test_where
    test_filter = "displayName eq 'country3'"
    stub_request(:get, /currencies\?\$filter=#{test_filter}/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              id: 3,
              code: 'C3',
              displayName: 'currency3',
              symbol: '$',
              amountDecimalPlaces: '2:2',
              amountRoundingPrecision: 0.01
            }
          ]
        }.to_json
      )

    response = @currency.where(test_filter)
    assert_equal response.first[:display_name], 'currency3'
  end

  def test_create
    stub_request(:post, /currencies/)
      .to_return(
        status: 200, 
        body: {
          code: 'C4',
          displayName: 'currency4',
          symbol: '$'
        }.to_json
      )

    response = @currency.create({
      code: 'C4',
      display_name: 'currency4',
      symbol: '$'
    })
    assert_equal response[:display_name], 'currency4'
  end


  def test_update
    test_id = '2'
    stub_request(:get, /currencies\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '3333',
          id: test_id,
          code: 'C5',
          displayName: 'currency5',
          symbol: '$',
          amountDecimalPlaces: '2:2',
          amountRoundingPrecision: 0.01
        }.to_json
      )

    stub_request(:patch, /currencies\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '4444',
          code: 'C6',
          displayName: 'currency6',
          symbol: '$'
        }.to_json
      )

    response = @currency.update(
      test_id,
      {
        code: 'C6',
        display_name: 'currency6',
        symbol: '$'
      }
    )
    assert_equal response[:display_name], 'currency6'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /currencies\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '5555',
          code: 'C7',
          displayName: 'currency7',
          symbol: '$'
        }.to_json
      )

    stub_request(:delete, /currencies\(#{test_id}\)/)
      .to_return(status: 204)

    assert @currency.destroy(test_id)
  end
end