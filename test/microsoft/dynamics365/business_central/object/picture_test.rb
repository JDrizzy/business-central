# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/picture_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::PictureTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @picture = @client.picture(parent: 'vendors', parent_id: '123', company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /picture/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 112,
              width: 500,
              height: 496,
              contentType: 'image\jpeg'
            }
          ]
        }.to_json
      )

    response = @picture.find_all
    assert_equal response.first[:content_type], 'image\jpeg'
  end

  def test_create
    stub_request(:patch, /picture/)
      .to_return(status: 204)

    response = @picture.create('ImageData')
    assert response
  end

  def test_update
    stub_request(:get, /picture/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          contentType: 'image\jpeg'
        }.to_json
      )

    stub_request(:patch, /picture/)
      .to_return(status: 204)

    response = @picture.update('ImageData')
    assert response
  end

  def test_delete
    test_id = 2
    stub_request(:get, /picture/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          contentType: 'image\jpeg'
        }.to_json
      )

    stub_request(:delete, /picture/)
      .to_return(status: 204)

    assert @picture.destroy(test_id)
  end
end
