# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/sales_invoice_test.rb

class BusinessCentral::Object::SalesInvoiceTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @sales_invoice = @client.sales_invoice(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /salesInvoices/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '1234',
              number: 1,
              customerPurchaseOrderReference: 'C1'
            }
          ]
        }.to_json
      )

    response = @sales_invoice.find_all
    assert_equal response.first[:customer_purchase_order_reference], 'C1'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /salesInvoices\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
              id: test_id,
              number: 2,
              customerPurchaseOrderReference: 'C2'
        }.to_json
      )

    response = @sales_invoice.find_by_id(test_id)
    assert_equal response[:customer_purchase_order_reference], 'C2'
  end

  def test_where
    test_filter = "customerPurchaseOrderReference eq 'C3'"
    stub_request(:get, /salesInvoices\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '345',
              number: 3,
              customerPurchaseOrderReference: 'C3'
            }
          ]
        }.to_json
      )

    response = @sales_invoice.where(test_filter)
    assert_equal response.first[:customer_purchase_order_reference], 'C3'
  end

  def test_create
    stub_request(:post, /salesInvoices/)
      .to_return(
        status: 200,
        body: {
          id: '678',
          number: 4,
          customerPurchaseOrderReference: 'C4'
        }.to_json
      )

    response = @sales_invoice.create(
      number: 4,
      customer_purchase_order_reference: 'C4'
    )
    assert_equal response[:customer_purchase_order_reference], 'C4'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /salesInvoices\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          number: 5,
          customerPurchaseOrderReference: 'C5'
        }.to_json
      )

    stub_request(:patch, /salesInvoices\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          number: 5,
          customerPurchaseOrderReference: 'C6'
        }.to_json
      )

    response = @sales_invoice.update(
      test_id,
      customer_purchase_order_reference: 'C6'
    )
    assert_equal response[:customer_purchase_order_reference], 'C6'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /salesInvoices\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          id: 7,
          number: 7,
          customerPurchaseOrderReference: 'C7'
        }.to_json
      )

    stub_request(:delete, /salesInvoices\(#{test_id}\)/)
      .to_return(status: 204)

    assert @sales_invoice.destroy(test_id)
  end

  def test_line_navigation
    stub_request(:get, %r{salesInvoices\(\d+\)\/salesInvoiceLines})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '123',
              documentId: 5,
              sequence: 10_000,
              itemId: 5,
              description: 'salesInvoiceLine1'
            }
          ]
        }.to_json
      )

    response = @client.sales_invoice(company_id: @company_id, id: '123')
                      .sales_invoice_line.find_all
    assert_equal response.first[:description], 'salesInvoiceLine1'
  end
end
