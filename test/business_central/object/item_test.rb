require "test_helper"
# rake test TEST=test/business_central/object/item_test.rb

class BusinessCentral::Object::ItemTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @client.authorize_from_token(
      token: '123',
      refresh_token: '456',
      expires_at: Time.now + 3600,
      expires_in: 3600
    )
    @item = @client.item(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /items/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'item1'
            }
          ]
        }.to_json,
      )

    response = @item.find_all
    assert_equal response.first[:display_name], 'item1'
  end

  def test_find_by_id
    test_item_id = '09876'
    stub_request(:get, /items\(#{test_item_id}\)/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'item2'
        }.to_json
      )

    response = @item.find_by_id(test_item_id)
    assert_equal response[:display_name], 'item2'
  end

  def test_where
    test_filter = "displayName eq 'item3'"
    stub_request(:get, /items\?\$filter=#{test_filter}/)
      .to_return(
        status: 200, 
        body: {
          'value': [
            {
              displayName: 'item3'
            }
          ]
        }.to_json
      )

    response = @item.where(test_filter)
    assert_equal response.first[:display_name], 'item3'
  end

  def test_create
    stub_request(:post, /items/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'item4'
        }.to_json
      )

    response = @item.create({
      display_name: 'item4',
      type: 'Inventory'
    })
    assert_equal response[:display_name], 'item4'
  end


  def test_update
    test_item_id = '011123'
    stub_request(:get, /items\(#{test_item_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '112',
          displayName: 'item5'
        }.to_json
      )

    stub_request(:patch, /items\(#{test_item_id}\)/)
      .to_return(
        status: 200, 
        body: {
          displayName: 'item6'
        }.to_json
      )

    response = @item.update(
      test_item_id,
      {
        display_name: 'item6',
        type: 'Inventory'
      }
    )
    assert_equal response[:display_name], 'item6'
  end

  def test_delete
    test_item_id = '0111245'
    stub_request(:get, /items\(#{test_item_id}\)/)
      .to_return(
        status: 200, 
        body: {
          etag: '113',
          displayName: 'item7'
        }.to_json
      )

    stub_request(:delete, /items\(#{test_item_id}\)/)
      .to_return(status: 204)

    assert @item.destroy(test_item_id)
  end
end