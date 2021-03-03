# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/sales_invoice_line_test.rb

class BusinessCentral::Object::SalesInvoiceLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @sales_invoice_line = @client.sales_invoice_line(
      company_id: @company_id,
      parent_id: '123'
    )
  end

  def test_invalid_sales_invoice_line_parent
    assert_raises(BusinessCentral::InvalidArgumentException) do
      @client.sales_invoice_line(
        company_id: @company_id,
        parent: 'something that doesnt exist',
        parent_id: '1'
      )
    end
  end

  def test_find_all
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              documentId: 1,
              sequence: 10_000,
              itemId: 1,
              description: 'salesInvoiceLine1'
            }
          ]
        }.to_json
      )

    response = @sales_invoice_line.find_all
    assert_equal response.first[:description], 'salesInvoiceLine1'
  end

  def test_find_by_id
    test_id = '2'
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          id: test_id,
          documentId: 2,
          sequence: 10_000,
          itemId: 2,
          description: 'salesInvoiceLine2'
        }.to_json
      )

    response = @sales_invoice_line.find_by_id(test_id)
    assert_equal response[:description], 'salesInvoiceLine2'
  end

  def test_where
    test_filter = "description eq 'salesInvoiceLine3'"
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines\?\$filter=#{test_filter}})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 3,
              documentId: 3,
              sequence: 10_000,
              itemId: 3,
              description: 'salesInvoiceLine3'
            }
          ]
        }.to_json
      )

    response = @sales_invoice_line.where(test_filter)
    assert_equal response.first[:description], 'salesInvoiceLine3'
  end

  def test_create
    stub_request(:post, %r{salesInvoices\(\d+\)\/salesInvoiceLines})
      .to_return(
        status: 200,
        body: {
          id: 4,
          documentId: 4,
          sequence: 20_000,
          itemId: 4,
          description: 'salesInvoiceLine4'
        }.to_json
      )

    response = @sales_invoice_line.create(
      document_id: 4,
      item_id: 4,
      description: 'salesInvoiceLine4'
    )
    assert_equal response[:id], 4
    assert_equal response[:description], 'salesInvoiceLine4'
  end

  def test_update
    test_id = '2'
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '3333',
          id: test_id,
          documentId: 5,
          sequence: 10_000,
          itemId: 5,
          description: 'salesInvoiceLine5'
        }.to_json
      )

    stub_request(:patch, %r{salesInvoices\(\d+\)\/salesInvoiceLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '4444',
          id: test_id,
          documentId: 5,
          sequence: 10_000,
          itemId: 5,
          description: 'salesInvoiceLine6'
        }.to_json
      )

    response = @sales_invoice_line.update(
      test_id,
      description: 'salesInvoiceLine6'
    )
    assert_equal response[:description], 'salesInvoiceLine6'
  end

  def test_delete
    test_id = '33333'
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '5555',
          id: test_id,
          documentId: 6,
          sequence: 10_000,
          itemId: 6,
          description: 'salesInvoiceLine6'
        }.to_json
      )

    stub_request(:delete, %r{salesInvoices\(\d+\)\/salesInvoiceLines\(#{test_id}\)})
      .to_return(status: 204)

    assert @sales_invoice_line.destroy(test_id)
  end
end
