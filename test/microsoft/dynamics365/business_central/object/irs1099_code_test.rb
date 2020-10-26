# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/irs1099_code_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::Irs1099CodeTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @irs1099_code = @client.irs1099_code(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /irs1099Codes/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              displayName: 'code1'
            }
          ]
        }.to_json
      )

    response = @irs1099_code.find_all
    assert_equal response.first[:display_name], 'code1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, /irs1099Codes\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          displayName: 'code2'
        }.to_json
      )

    response = @irs1099_code.find_by_id(test_id)
    assert_equal response[:display_name], 'code2'
  end

  def test_where
    test_filter = "displayName eq 'customer3'"
    stub_request(:get, /irs1099Codes\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              displayName: 'code3'
            }
          ]
        }.to_json
      )

    response = @irs1099_code.where(test_filter)
    assert_equal response.first[:display_name], 'code3'
  end

  def test_create
    stub_request(:post, /irs1099Codes/)
      .to_return(
        status: 200,
        body: {
          displayName: 'code4'
        }.to_json
      )

    response = @irs1099_code.create(
      display_name: 'code4'
    )
    assert_equal response[:display_name], 'code4'
  end

  def test_update
    test_id = '2'
    stub_request(:get, /irs1099Codes\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          id: test_id,
          displayName: 'code5'
        }.to_json
      )

    stub_request(:patch, /irs1099Codes\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '4444',
          displayName: 'code6'
        }.to_json
      )

    response = @irs1099_code.update(
      test_id,
      display_name: 'code6'
    )
    assert_equal response[:display_name], 'code6'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /irs1099Codes\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          displayName: 'code7'
        }.to_json
      )

    stub_request(:delete, /irs1099Codes\(#{test_id}\)/)
      .to_return(status: 204)

    assert @irs1099_code.destroy(test_id)
  end
end
