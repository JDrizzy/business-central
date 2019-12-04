require "test_helper"
# rake test TEST=test/business_central/object/purchase_invoice_line_test.rb

class BusinessCentral::Object::PurchaseInvoiceLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @purchase_invoice_id = '789456'
    @client = BusinessCentral::Client.new
    @purchase_invoice_line = @client.purchase_invoice_line(
      company_id: @company_id,
      purchase_invoice_id: @purchase_invoice_id
    )
  end

  def test_find_all
    stub_request(:get, /purchaseInvoiceLines/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              description: 'po line 1'
            }
          ]
        }.to_json,
      )

    response = @purchase_invoice_line.find_all
    assert_equal response.first[:description], 'po line 1'
  end

  def test_find_by_id
    test_purchase_invoice_line_id = '09876'
    stub_request(:get, /purchaseInvoiceLines\(#{test_purchase_invoice_line_id}\)/)
      .to_return(
        status: 200, 
        body: {
          description: 'po line 2'
        }.to_json
      )

    response = @purchase_invoice_line.find_by_id(test_purchase_invoice_line_id)
    assert_equal response[:description], 'po line 2'
  end

  def test_where
    test_filter = "description eq 'po line 3'"
    stub_request(:get, /purchaseInvoiceLines\?\$filter=#{test_filter}/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              description: 'po line 3'
            }
          ]
        }.to_json
      )

    response = @purchase_invoice_line.where(test_filter)
    assert_equal response.first[:description], 'po line 3'
  end

  def test_create
    stub_request(:post, /purchaseInvoiceLines/)
      .to_return(
        status: 200, 
        body: {
          description: 'po line 4'
        }.to_json
      )

    response = @purchase_invoice_line.create({
      description: 'po line 4'
    })
    assert_equal response[:description], 'po line 4'
  end

  def test_update
    test_purchase_invoice_line_id = '011123'
    stub_request(:get, /purchaseInvoiceLines\(#{test_purchase_invoice_line_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '112',
          description: 'po line 5'
        }.to_json
      )

    stub_request(:patch, /purchaseInvoiceLines\(#{test_purchase_invoice_line_id}\)/)
      .to_return(
        status: 200, 
        body: {
          description: 'po line 6'
        }.to_json
      )

    response = @purchase_invoice_line.update(
      test_purchase_invoice_line_id,
      {
        description: 'po line 6'
      }
    )
    assert_equal response[:description], 'po line 6'
  end

  def test_delete
    test_purchase_invoice_line_id = '0111245'
    stub_request(:get, /purchaseInvoiceLines\(#{test_purchase_invoice_line_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '113',
          description: 'po line 6'
        }.to_json
      )

    stub_request(:delete, /purchaseInvoiceLines\(#{test_purchase_invoice_line_id}\)/)
      .to_return(status: 204)

    assert @purchase_invoice_line.destroy(test_purchase_invoice_line_id)
  end
end