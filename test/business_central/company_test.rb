require "test_helper"

class BusinessCentral::CompanyTest < Minitest::Test
  def setup
    @url = BusinessCentral::Application::DEFAULT_URL
    @client = BusinessCentral::Application.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @company = BusinessCentral::Company.new(@client)
  end

  def test_find_all
    stub_request(:get, "#{@url}/companies")
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'business1'
            }
          ]
        }.to_json
      )

    
    response = @company.find_all
    assert_equal response.first[:display_name], 'business1'
  end

  def test_find_by_id
    test_company_id = '123'
    stub_request(:get, "#{@url}/companies(#{test_company_id})")
      .to_return(
        status: 200, 
        body: {
          displayName: 'business2'
        }.to_json
      )

    response = @company.find_by_id(test_company_id)
    assert_equal response[:display_name], 'business2'
  end
end