# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/item_category_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::ItemCategoryTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @item_category = @client.item_category(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /itemCategories/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              code: '123',
              displayName: 'item_category1'
            }
          ]
        }.to_json
      )

    response = @item_category.find_all
    assert_equal response.first[:display_name], 'item_category1'
  end

  def test_find_by_id
    test_item_category_id = '345'
    stub_request(:get, /itemCategories\(#{test_item_category_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_item_category_id,
          displayName: 'item_category2'
        }.to_json
      )

    response = @item_category.find_by_id(test_item_category_id)
    assert_equal response[:display_name], 'item_category2'
  end

  def test_where
    test_filter = "displayName eq 'item_category3'"
    stub_request(:get, /itemCategories\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              code: '678',
              displayName: 'item_category3'
            }
          ]
        }.to_json
      )

    response = @item_category.where(test_filter)
    assert_equal response.first[:display_name], 'item_category3'
  end

  def test_create
    stub_request(:post, /itemCategories/)
      .to_return(
        status: 200,
        body: {
          displayName: 'item_category4'
        }.to_json
      )

    response = @item_category.create(
      display_name: 'item_category4'
    )
    assert_equal response[:display_name], 'item_category4'
  end

  def test_update
    test_item_category_id = '011123'
    stub_request(:get, /itemCategories\(#{test_item_category_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          displayName: 'item_category5'
        }.to_json
      )

    stub_request(:patch, /itemCategories\(#{test_item_category_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'item_category6'
        }.to_json
      )

    response = @item_category.update(
      test_item_category_id,
      display_name: 'item_category6'
    )
    assert_equal response[:display_name], 'item_category6'
  end

  def test_delete
    test_item_category_id = '0111245'
    stub_request(:get, /itemCategories\(#{test_item_category_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          displayName: 'item_category7'
        }.to_json
      )

    stub_request(:delete, /itemCategories\(#{test_item_category_id}\)/)
      .to_return(status: 204)

    assert @item_category.destroy(test_item_category_id)
  end
end
