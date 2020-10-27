# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class Attachment < Base
      OBJECT = 'attachments'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      def update(parent_id:, attachment_id:, **params)
        url = "#{build_url(child_path: OBJECT)}(parentId=#{parent_id},id=#{attachment_id})/content"
        Request.call(:patch, @client, url, etag: '', params: {}) do |request|
          request['Content-Type'] = 'application/json'
          request['If-Match'] = 'application/json'
          request.body = Request.convert(params)
        end
      end

      def destroy(parent_id:, attachment_id:)
        url = "#{build_url(child_path: OBJECT)}(#{parent_id},#{attachment_id})"
        Request.call(:delete, @client, url, etag: '')
      end
    end
  end
end
