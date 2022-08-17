# frozen_string_literal: true

module BusinessCentral
  module Object
    class Picture < Base
      using Refinements::Strings

      def update(id, data)
        object = find_all
        Request.call(:patch, @client, "#{build_url(object_id: id)}/content", etag: object[:etag], params: {}) do |request|
          request['Content-Type'] = 'application/octet-stream'
          request.body = data
        end
      end
    end
  end
end
