require "test_helper"
# rake test TEST=test/business_central/object/customer_sale_test.rb

class BusinessCentral::Object::CustomerSaleTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @customer_sale = @client.customer_sale(
      company_id: @company_id
    )
  end

  def test_find_all
    stub_request(:get, /customerSales/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              customerId: 1,
              customerNumber: 'C1',
              name: 'Jarrad',
              totalSalesAmount: 0
            }
          ]
        }.to_json,
      )

    response = @customer_sale.find_all
    assert_equal response.first[:customer_number], 'C1'
  end

  def test_find_by_id
    test_id = 2
    stub_request(:get, /customerSales\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          customerId: 2,
          customerNumber: 'C2',
          name: 'Jrad',
          totalSalesAmount: 0
        }.to_json
      )

    response = @customer_sale.find_by_id(test_id)
    assert_equal response[:customer_number], 'C2'
  end

  def test_where
    test_filter = "customerNumber eq 'C3'"
    stub_request(:get, /customerSales\?\$filter=#{test_filter}/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              customerId: 3,
              customerNumber: 'C3',
              name: 'Jazza',
              totalSalesAmount: 0
            }
          ]
        }.to_json
      )

    response = @customer_sale.where(test_filter)
    assert_equal response.first[:customer_number], 'C3'
  end
end