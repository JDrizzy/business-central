# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/purchase_invoice_test.rb

class BusinessCentral::Object::PurchaseInvoiceTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @purchase_invoice = @client.purchase_invoice(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /purchaseInvoices/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'po1'
            }
          ]
        }.to_json
      )

    response = @purchase_invoice.find_all
    assert_equal response.first[:display_name], 'po1'
  end

  def test_find_by_id
    test_purchase_invoice_id = '09876'
    stub_request(:get, /purchaseInvoices\(#{test_purchase_invoice_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'po2'
        }.to_json
      )

    response = @purchase_invoice.find_by_id(test_purchase_invoice_id)
    assert_equal response[:display_name], 'po2'
  end

  def test_where
    test_filter = "displayName eq 'po3'"
    stub_request(:get, /purchaseInvoices\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'po3'
            }
          ]
        }.to_json
      )

    response = @purchase_invoice.where(test_filter)
    assert_equal response.first[:display_name], 'po3'
  end

  def test_create
    stub_request(:post, /purchaseInvoices/)
      .to_return(
        status: 200,
        body: {
          displayName: 'po4'
        }.to_json
      )

    response = @purchase_invoice.create(
      display_name: 'po4'
    )
    assert_equal response[:display_name], 'po4'
  end

  def test_update
    test_purchase_invoice_id = '011123'
    stub_request(:get, /purchaseInvoices\(#{test_purchase_invoice_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          displayName: 'po5'
        }.to_json
      )

    stub_request(:patch, /purchaseInvoices\(#{test_purchase_invoice_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'po6'
        }.to_json
      )

    response = @purchase_invoice.update(
      test_purchase_invoice_id,
      display_name: 'po6'
    )
    assert_equal response[:display_name], 'po6'
  end

  def test_delete
    test_purchase_invoice_id = '0111245'
    stub_request(:get, /purchaseInvoices\(#{test_purchase_invoice_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          displayName: 'po7'
        }.to_json
      )

    stub_request(:delete, /purchaseInvoices\(#{test_purchase_invoice_id}\)/)
      .to_return(status: 204)

    assert @purchase_invoice.destroy(test_purchase_invoice_id)
  end
end
