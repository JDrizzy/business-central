# frozen_string_literal: true

module BusinessCentral
  module Object
    class Attachments < Base
      OBJECT = 'attachments'

      def initialize(client, **args)
        super(client, { **args, object_name: OBJECT })
      end

      def update(parent_id:, attachment_id:, **params)
        url = "#{build_url}(parentId=#{parent_id},id=#{attachment_id})/content"
        Request.call(:patch, @client, url, etag: '', params: {}) do |request|
          request['Content-Type'] = 'application/json'
          request['If-Match'] = 'application/json'
          request.body = Request.convert(params)
        end
      end

      # Test further
      # def destroy(parent_id:, attachment_id:)
      #   url = "#{build_url(child_path: OBJECT)}(#{parent_id},#{attachment_id})"
      #   Request.call(:delete, @client, url, etag: '')
      # end
    end
  end
end
