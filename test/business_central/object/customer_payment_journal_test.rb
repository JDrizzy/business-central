require "test_helper"
# rake test TEST=test/business_central/object/customer_payment_journal_test.rb

class BusinessCentral::Object::CustomerPaymentJournalTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @customer_payment_journal = @client.customer_payment_journal(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /customerPaymentJournals/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              id: 1,
              code: 'GENERAL',
              displayName: 'GENERAL 1'
            }
          ]
        }.to_json,
      )

    response = @customer_payment_journal.find_all
    assert_equal response.first[:display_name], 'GENERAL 1'
  end

  def test_find_by_id
    test_id = 2
    stub_request(:get, /customerPaymentJournals\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          id: test_id,
          code: 'GENERAL',
          displayName: 'GENERAL 2'
        }.to_json
      )

    response = @customer_payment_journal.find_by_id(test_id)
    assert_equal response[:display_name], 'GENERAL 2'
  end

  def test_where
    test_filter = "displayName eq 'GENERAL 3'"
    stub_request(:get, /customerPaymentJournals\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              code: 'GENERAL',
              displayName: 'GENERAL 3'
            }
          ]
        }.to_json
      )

    response = @customer_payment_journal.where(test_filter)
    assert_equal response.first[:display_name], 'GENERAL 3'
  end

  def test_create
    stub_request(:post, /customerPaymentJournals/)
      .to_return(
        status: 200, 
        body: {
          id: 1,
          code: 'GENERAL',
          displayName: 'GENERAL 4'
        }.to_json
      )

    response = @customer_payment_journal.create({
      display_name: 'GENERAL 4'
    })
    assert_equal response[:display_name], 'GENERAL 4'
  end


  def test_update
    test_id = 2
    stub_request(:get, /customerPaymentJournals\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '3333',
          id: test_id,
          code: 'GENERAL',
          displayName: 'GENERAL 4'
        }.to_json
      )

    stub_request(:patch, /customerPaymentJournals\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '4444',
          id: test_id,
          code: 'GENERAL',
          displayName: 'GENERAL 5'
        }.to_json
      )

    response = @customer_payment_journal.update(
      test_id,
      {
        display_name: 'GENERAL 5'
      }
    )
    assert_equal response[:display_name], 'GENERAL 5'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, /customerPaymentJournals\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '5555',
          id: test_id,
          code: 'GENERAL',
          displayName: 'GENERAL 5'
        }.to_json
      )

    stub_request(:delete, /customerPaymentJournals\(#{test_id}\)/)
      .to_return(status: 204)

    assert @customer_payment_journal.destroy(test_id)
  end
end