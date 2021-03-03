# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/journal_test.rb

class BusinessCentral::Object::JournalTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @journal = @client.journal(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /journals/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              code: '123',
              displayName: 'journal1'
            }
          ]
        }.to_json
      )

    response = @journal.find_all
    assert_equal response.first[:display_name], 'journal1'
  end

  def test_find_by_id
    test_journal_id = '09876'
    stub_request(:get, /journals\(#{test_journal_id}\)/)
      .to_return(
        status: 200,
        body: {
          code: '123',
          displayName: 'journal1'
        }.to_json
      )

    response = @journal.find_by_id(test_journal_id)
    assert_equal response[:display_name], 'journal1'
  end

  def test_where
    test_filter = "displayName eq 'journal2'"
    stub_request(:get, /journals\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              code: '456',
              displayName: 'journal2'
            }
          ]
        }.to_json
      )

    response = @journal.where(test_filter)
    assert_equal response.first[:display_name], 'journal2'
  end

  def test_create
    stub_request(:post, /journals/)
      .to_return(
        status: 200,
        body: {
          code: '789',
          displayName: 'journal3'
        }.to_json
      )

    response = @journal.create(
      code: '789',
      display_name: 'journal3'
    )
    assert_equal response[:display_name], 'journal3'
  end

  def test_update
    test_journal_id = '011123'
    stub_request(:get, /journals\(#{test_journal_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          displayName: 'journal4'
        }.to_json
      )

    stub_request(:patch, /journals\(#{test_journal_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'journal5'
        }.to_json
      )

    response = @journal.update(
      test_journal_id,
      display_name: 'journal5'
    )
    assert_equal response[:display_name], 'journal5'
  end

  def test_delete
    test_journal_id = '0111245'
    stub_request(:get, /journals\(#{test_journal_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          displayName: 'journal6'
        }.to_json
      )

    stub_request(:delete, /journals\(#{test_journal_id}\)/)
      .to_return(status: 204)

    assert @journal.destroy(test_journal_id)
  end

  def test_line_navigation
    stub_request(:get, %r{journals\(\d+\)\/journalLines})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              journalDisplayName: 'journal1',
              lineNumber: 1000,
              description: 'journalLine1'
            }
          ]
        }.to_json
      )

    response = @client.journal(company_id: @company_id, id: '123')
                      .journal_line.find_all
    assert_equal response.first[:line_number], 1000
  end
end
