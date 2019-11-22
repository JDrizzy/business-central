require "test_helper"

class BusinessCentral::ItemTest < Minitest::Test
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
    @item = BusinessCentral::Item.new(@client, @company_id)
  end

  def test_find_all
    stub_request(:get, "#{@url}/items")
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
    assert response.first.has_key?(:display_name)
    assert_equal response.first[:display_name], 'item1'
  end

  def test_find_by_id
    test_item_id = '09876'
    stub_request(:get, "#{@url}/items(#{test_item_id})")
      .to_return(
        status: 200, 
        body: {
          displayName: 'item2'
        }.to_json
      )

    response = @item.find_by_id(test_item_id)
    assert response.has_key?(:display_name)
    assert_equal response[:display_name], 'item2'
  end

  def test_where
    test_filter = "displayName eq 'item3'"
    stub_request(:get, "#{@url}/items?$filter=#{test_filter}")
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
    assert response.first.has_key?(:display_name)
    assert_equal response.first[:display_name], 'item3'
  end

  def test_create
    stub_request(:post, "#{@url}/items")
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
    assert response.has_key?(:display_name)
    assert_equal response[:display_name], 'item4'
  end
end