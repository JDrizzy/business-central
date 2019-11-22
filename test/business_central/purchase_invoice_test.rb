require "test_helper"

class BusinessCentral::PurchaseInvoiceTest < Minitest::Test
  def setup
    @company_id = '123456'
    @url = "#{BusinessCentral::Application::DEFAULT_URL}/companies(#{@company_id})"
    @client = BusinessCentral::Application.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @purchase_invoice = BusinessCentral::PurchaseInvoice.new(@client, @company_id)
  end

  def test_find_all
    stub_request(:get, "#{@url}/purchaseInvoices")
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'po1'
            }
          ]
        }.to_json,
      )

    response = @purchase_invoice.find_all
    assert_equal response.first[:display_name], 'po1'
  end

  def test_find_by_id
    test_purchase_invoice_id = '09876'
    stub_request(:get, "#{@url}/purchaseInvoices(#{test_purchase_invoice_id})")
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
    stub_request(:get, "#{@url}/purchaseInvoices?$filter=#{test_filter}")
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
    stub_request(:post, "#{@url}/purchaseInvoices")
      .to_return(
        status: 200, 
        body: {
          displayName: 'po4'
        }.to_json
      )

    response = @purchase_invoice.create({
      display_name: 'po4'
    })
    assert_equal response[:display_name], 'po4'
  end
end