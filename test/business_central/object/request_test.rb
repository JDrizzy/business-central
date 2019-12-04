require "test_helper"
# rake test TEST=test/business_central/object/request_test.rb

class BusinessCentral::Object::RequestTest < Minitest::Test
  def setup
    @url = BusinessCentral::Client::DEFAULT_URL
    @client = BusinessCentral::Client.new
  end

  def test_get_request
    stub_request(:get, @url)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'value1'
            }
          ]
        }.to_json,
      )

    response = BusinessCentral::Object::Request.get(@client, @url)

    assert_equal 'value1', response.first[:display_name]
  end

  def test_post_request
    stub_request(:post, @url)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'value2'
            }
          ]
        }.to_json,
      )

    response = BusinessCentral::Object::Request.post(@client, @url, { display_name: 'value2' })

    assert_equal 'value2', response.first[:display_name]
  end

  def test_patch_request
    stub_request(:patch, @url)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'value3'
            }
          ]
        }.to_json,
      )

    response = BusinessCentral::Object::Request.patch(@client, @url, '1', { display_name: 'value3' })

    assert_equal 'value3', response.first[:display_name]
  end

  def test_delete_request
    stub_request(:delete, @url)
      .to_return(status: 204)

    assert BusinessCentral::Object::Request.delete(@client, @url, '1')
  end

  def test_request_convert_parameters
    param = { new_key: 'value' }
    request = JSON.parse(BusinessCentral::Object::Request.convert(param))
    assert request.has_key?("newKey")
  end
end