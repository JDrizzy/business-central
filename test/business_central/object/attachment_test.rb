# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/attachment_test.rb

class BusinessCentral::Object::AttachmentTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @attachment = @client.attachment(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /attachments/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '111',
              fileName: 'attachment1.pdf'
            }
          ]
        }.to_json
      )

    response = @attachment.find_all
    assert_equal response.first[:file_name], 'attachment1.pdf'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /attachments\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: '222',
          fileName: 'attachment2.jpg'
        }.to_json
      )

    response = @attachment.find_by_id(test_id)
    assert_equal response[:file_name], 'attachment2.jpg'
  end

  def test_where
    test_filter = "fileName eq 'attachment3.png'"
    stub_request(:get, /attachments\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: '333',
              fileName: 'attachment3.png'
            }
          ]
        }.to_json
      )

    response = @attachment.where(test_filter)
    assert_equal response.first[:file_name], 'attachment3.png'
  end

  def test_create
    stub_request(:post, /attachments/)
      .to_return(
        status: 200,
        body: {
          fileName: 'attachment4.gif'
        }.to_json
      )

    response = @attachment.create(
      file_name: 'attachment4.gif'
    )
    assert_equal response[:file_name], 'attachment4.gif'
  end

  def test_update
    test_parent_id = '011123'
    test_attachment_id = '11123'
    stub_request(:get, /attachments\(parentId=#{test_parent_id},id=#{test_attachment_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          fileName: 'attachment5.pdf'
        }.to_json
      )

    stub_request(:patch, /attachments\(parentId=#{test_parent_id},id=#{test_attachment_id}\)/)
      .to_return(
        status: 200,
        body: {
          fileName: 'attachment6.pdf'
        }.to_json
      )

    response = @attachment.update(
      parent_id: test_parent_id,
      attachment_id: test_attachment_id,
      file_name: 'attachment6.pdf'
    )
    assert_equal response[:file_name], 'attachment6.pdf'
  end

  def test_delete
    test_parent_id = '011124'
    test_attachment_id = '11124'

    stub_request(:delete, /attachments\(#{test_parent_id},#{test_attachment_id}\)/)
      .to_return(status: 204)

    assert @attachment.destroy(parent_id: test_parent_id, attachment_id: test_attachment_id)
  end
end
