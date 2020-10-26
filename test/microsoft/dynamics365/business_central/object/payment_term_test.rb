# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/payment_term_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::PaymentTermTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @payment_term = @client.payment_term(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /paymentTerms/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              code: 'PM1',
              displayName: 'paymentTerm1'
            }
          ]
        }.to_json
      )

    response = @payment_term.find_all
    assert_equal response.first[:display_name], 'paymentTerm1'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /paymentTerms\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: 'PM2',
          displayName: 'paymentTerm2'
        }.to_json
      )

    response = @payment_term.find_by_id(test_id)
    assert_equal response[:display_name], 'paymentTerm2'
  end

  def test_where
    test_filter = "displayName eq 'paymentTerm3'"
    stub_request(:get, /paymentTerms\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              code: 'PM3',
              displayName: 'paymentTerm3'
            }
          ]
        }.to_json
      )

    response = @payment_term.where(test_filter)
    assert_equal response.first[:display_name], 'paymentTerm3'
  end

  def test_create
    stub_request(:post, /paymentTerms/)
      .to_return(
        status: 200,
        body: {
          id: 4,
          code: 'PM4',
          displayName: 'paymentTerm4'
        }.to_json
      )

    response = @payment_term.create(
      code: 'PM4',
      display_name: 'paymentTerm4'
    )
    assert_equal response[:display_name], 'paymentTerm4'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /paymentTerms\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          code: 'PM5',
          displayName: 'paymentTerm5'
        }.to_json
      )

    stub_request(:patch, /paymentTerms\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          code: 'PM6',
          displayName: 'paymentTerm6'
        }.to_json
      )

    response = @payment_term.update(
      test_id,
      code: 'PM6',
      display_name: 'paymentTerm6'
    )
    assert_equal response[:display_name], 'paymentTerm6'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /paymentTerms\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          code: 'PM7',
          displayName: 'paymentTerm6'
        }.to_json
      )

    stub_request(:delete, /paymentTerms\(#{test_id}\)/)
      .to_return(status: 204)

    assert @payment_term.destroy(test_id)
  end
end
