require "test_helper"

class PurchaseInvoiceLineTest < Minitest::Test
  def setup
    @company_id = '123456'
    @purchase_invoice_id = '789456'
    @url = "#{BusinessCentral::Application::DEFAULT_URL}/companies(#{@company_id})/purchaseInvoices(#{@purchase_invoice_id})"
    @client = BusinessCentral::Application.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @purchase_invoice_line = BusinessCentral::PurchaseInvoiceLine.new(
      @client,
      @company_id,
      @purchase_invoice_id
    )
  end

  def test_find_all
    stub_request(:get, "#{@url}/purchaseInvoiceLines")
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
    stub_request(:get, "#{@url}/purchaseInvoiceLines(#{test_purchase_invoice_line_id})")
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
    stub_request(:get, "#{@url}/purchaseInvoiceLines?$filter=#{test_filter}")
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
    stub_request(:post, "#{@url}/purchaseInvoiceLines")
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
end