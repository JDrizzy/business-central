# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/picture_test.rb

class BusinessCentral::Object::PictureTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @picture = @client.items(id: 123, company_id: @company_id).picture
  end

  def test_find_all
    stub_request(:get, %r{companies\(#{@company_id}\)/items\(123\)/picture})
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

  def test_update
    stub_request(:get, %r{companies\(#{@company_id}\)/items\(123\)/picture})
      .to_return(
        status: 200,
        body: {
          etag: '112',
          contentType: 'image\jpeg'
        }.to_json
      )

    stub_request(:patch, %r{companies\(#{@company_id}\)/items\(123\)/picture\(1\)/content})
      .to_return(status: 204)

    response = @picture.update(1, 'ImageData')
    assert response
  end

  def test_delete
    test_id = 2
    stub_request(:get, %r{companies\(#{@company_id}\)/items\(123\)/picture\(#{test_id}\)})
      .to_return(
        status: 200,
        body: {
          etag: '113',
          contentType: 'image\jpeg'
        }.to_json
      )

    stub_request(:delete, %r{companies\(#{@company_id}\)/items\(123\)/picture\(#{test_id}\)})
      .to_return(status: 204)

    assert @picture.destroy(test_id)
  end
end
