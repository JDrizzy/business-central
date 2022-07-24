# frozen_string_literal: true

module BusinessCentral
  module Object
    class Picture < Base
      def create(data)
        Request.call(:patch, @client, "#{build_url}/content", etag: '', params: {}) do |request|
          request['Content-Type'] = 'application/octet-stream'
          request['If-Match'] = '*'
          request.body = data
        end
      end

      def update(id, data)
        url = build_url(object_id: id)
        object = Request.get(@client, url)
        Request.call(:patch, @client, "#{url}/content", etag: object[:etag], params: {}) do |request|
          request['Content-Type'] = 'application/octet-stream'
          request.body = data
        end
      end
    end
  end
end
