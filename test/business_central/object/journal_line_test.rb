# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/journal_line_test.rb

class BusinessCentral::Object::JournalLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @journal_line = @client.journal_line(
      company_id: @company_id,
      parent: 'journals',
      parent_id: '123'
    )
  end

  def test_invalid_journal_line_parent
    assert_raises(BusinessCentral::InvalidArgumentException) do
      @client.journal_line(
        company_id: @company_id,
        parent: 'something that doesnt exist',
        parent_id: '1'
      )
    end
  end

  def test_find_all
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

    response = @journal_line.find_all
    assert_equal response.first[:description], 'journalLine1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, %r{journals\(\d+\)\/journalLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          id: test_id,
          journalDisplayName: 'journal1',
          lineNumber: 2000,
          description: 'journalLine2'
        }.to_json
      )

    response = @journal_line.find_by_id(test_id)
    assert_equal response[:description], 'journalLine2'
  end

  def test_where
    test_filter = "description eq 'journalLine3'"
    stub_request(:get, %r{journals\(\d+\)\/journalLines\?\$filter=#{test_filter}})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              journalDisplayName: 'journal1',
              lineNumber: 3000,
              description: 'journalLine3'
            }
          ]
        }.to_json
      )

    response = @journal_line.where(test_filter)
    assert_equal response.first[:description], 'journalLine3'
  end

  def test_create
    stub_request(:post, %r{journals\(\d+\)\/journalLines})
      .to_return(
        status: 200,
        body: {
          id: 4,
          journalDisplayName: 'journal1',
          lineNumber: 4000,
          description: 'journalLine4'
        }.to_json
      )

    response = @journal_line.create(
      description: 'journalLine4'
    )
    assert_equal response[:id], 4
  end

  def test_update
    test_id = '2'
    stub_request(:get, %r{journals\(\d+\)\/journalLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          id: test_id,
          journalDisplayName: 'journal1',
          lineNumber: 4000,
          description: 'journalLine4'
        }.to_json
      )

    stub_request(:patch, %r{journals\(\d+\)\/journalLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '4444',
          id: test_id,
          lineNumber: 4000,
          description: 'journalLine5'
        }.to_json
      )

    response = @journal_line.update(
      test_id,
      description: 'journalLine5'
    )
    assert_equal response[:description], 'journalLine5'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, %r{journals\(\d+\)\/journalLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          id: test_id,
          lineNumber: 5000,
          description: 'journalLine5'
        }.to_json
      )

    stub_request(:delete, %r{journals\(\d+\)\/journalLines\(#{test_id}\)})
      .to_return(status: 204)

    assert @journal_line.destroy(test_id)
  end
end
