# frozen_string_literal: true

module BusinessCentral
  module Object
    class Picture < Base
      OBJECT = 'picture'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        items
        customers
        vendors
        employees
      ].freeze

      def initialize(client, parent:, parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent,
          id: parent_id
        }
        @parent_id = parent_id
      end

      def create(data)
        url = "#{build_url(parent_path: @parent_path, child_path: object_name)}(#{@parent_id})/content"
        Request.call(:patch, @client, url, etag: '', params: {}) do |request|
          request['Content-Type'] = 'application/octet-stream'
          request['If-Match'] = '*'
          request.body = data
        end
      end

      def update(data)
        url = "#{build_url(parent_path: @parent_path, child_path: object_name)}(#{@parent_id})"
        object = Request.get(@client, url)
        url = "#{build_url(parent_path: @parent_path, child_path: object_name)}(#{@parent_id})/content"
        Request.call(:patch, @client, url, etag: object[:etag], params: {}) do |request|
          request['Content-Type'] = 'application/octet-stream'
          request.body = data
        end
      end
    end
  end
end
