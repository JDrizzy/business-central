require "test_helper"
# rake test TEST=test/business_central/object/vendor_test.rb

class BusinessCentral::Object::VendorTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @vendor = @client.vendor(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /\/vendors/)
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
    assert_equal response.first[:display_name], 'vendor1'
  end

  def test_find_by_id
    test_vendor_id = '09876'
    stub_request(:get, /vendors\(#{test_vendor_id}\)/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'vendor2'
        }.to_json
      )

    response = @vendor.find_by_id(test_vendor_id)
    assert_equal response[:display_name], 'vendor2'
  end

  def test_where
    test_filter = "displayName eq 'vendor3'"
    stub_request(:get, /vendors\?\$filter=#{test_filter}/)
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
    assert_equal response.first[:display_name], 'vendor3'
  end

  def test_create
    stub_request(:post, /vendors/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'vendor4'
        }.to_json
      )

    response = @vendor.create({
      display_name: 'vendor4'
    })
    assert_equal response[:display_name], 'vendor4'
  end

  def test_update
    test_vendor_id = '011123'
    stub_request(:get, /vendors\(#{test_vendor_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '112',
          displayName: 'vendor5'
        }.to_json
      )

    stub_request(:patch, /vendors\(#{test_vendor_id}\)/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'vendor6'
        }.to_json
      )

    response = @vendor.update(
      test_vendor_id,
      {
        display_name: 'vendor6'
      }
    )
    assert_equal response[:display_name], 'vendor6'
  end

  def test_delete
    test_vendor_id = '0111245'
    stub_request(:get, /vendors\(#{test_vendor_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '113',
          displayName: 'vendor7'
        }.to_json
      )

    stub_request(:delete, /vendors\(#{test_vendor_id}\)/)
      .to_return(status: 204)

    assert @vendor.destroy(test_vendor_id)
  end
end