# frozen_string_literal: true

module BusinessCentral
  module Object
    class Attachments < Base
      using Refinements::Strings

      OBJECT = 'attachments'

      def initialize(client, **args)
        super(client, **args.merge!({ object_name: OBJECT }))
      end

      def update(parent_id:, attachment_id:, **params)
        url = "#{build_url}(parentId=#{parent_id},id=#{attachment_id})/content"
        Request.call(:patch, @client, url, etag: '', params: {}) do |request|
          request['Content-Type'] = 'application/json'
          request['If-Match'] = 'application/json'
          request.body = Request.convert(params)
        end
      end

      def destroy(id)
        Request.call(:delete, @client, build_url(object_id: id), etag: '')
      end
    end
  end
end
