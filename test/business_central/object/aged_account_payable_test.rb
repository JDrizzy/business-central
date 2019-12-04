require "test_helper"
# rake test TEST=test/business_central/object/aged_account_payable_test.rb

class BusinessCentral::Object::AgedAccountPayableTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @aged_account_payable = @client.aged_account_payable(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /agedAccountsPayable/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              name: 'vendor1'
            }
          ]
        }.to_json
      )

    
    response = @aged_account_payable.find_all
    assert_equal response.first[:name], 'vendor1'
  end

  def test_find_by_id
    test_id = '123'
    stub_request(:get, /agedAccountsPayable\(#{test_id}\)/)
      .to_return(
        status: 200, 
        body: {
          name: 'vendor2'
        }.to_json
      )

    response = @aged_account_payable.find_by_id(test_id)
    assert_equal response[:name], 'vendor2'
  end

  def test_create
    assert_raises BusinessCentral::NoSupportedMethod do
      @aged_account_payable.create({})
    end
  end

  def test_update
    assert_raises BusinessCentral::NoSupportedMethod do
      @aged_account_payable.update('123', {})
    end
  end

  def test_delete
    assert_raises BusinessCentral::NoSupportedMethod do
      @aged_account_payable.destroy('123')
    end
  end
end