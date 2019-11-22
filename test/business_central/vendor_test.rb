require "test_helper"

class BusinessCentral::VendorTest < Minitest::Test
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
    @vendor = BusinessCentral::Vendor.new(@client, @company_id)
  end

  def test_find_all
    stub_request(:get, "#{@url}/vendors")
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'vendor1'
            }
          ]
        }.to_json,
      )

    response = @vendor.find_all
    assert response.first.has_key?(:display_name)
    assert_equal response.first[:display_name], 'vendor1'
  end

  def test_find_by_id
    test_vendor_id = '09876'
    stub_request(:get, "#{@url}/vendors(#{test_vendor_id})")
      .to_return(
        status: 200, 
        body: {
          displayName: 'vendor2'
        }.to_json
      )

    response = @vendor.find_by_id(test_vendor_id)
    assert response.has_key?(:display_name)
    assert_equal response[:display_name], 'vendor2'
  end

  def test_where
    test_filter = "displayName eq 'vendor3'"
    stub_request(:get, "#{@url}/vendors?$filter=#{test_filter}")
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'vendor3'
            }
          ]
        }.to_json
      )

    response = @vendor.where(test_filter)
    assert response.first.has_key?(:display_name)
    assert_equal response.first[:display_name], 'vendor3'
  end

  def test_create
    stub_request(:post, "#{@url}/vendors")
      .to_return(
        status: 200, 
        body: {
          displayName: 'vendor4'
        }.to_json
      )

    response = @vendor.create({
      display_name: 'vendor4'
    })
    assert response.has_key?(:display_name)
    assert_equal response[:display_name], 'vendor4'
  end
end