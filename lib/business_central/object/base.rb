# frozen_string_literal: true

module BusinessCentral
  module Object
    class Base
      attr_reader :client

      def initialize(client, **args)
        @client = client
        @object_path = args.fetch(
          :object_path,
          [
            {
              path: 'companies',
              id: args.fetch(:company_id, client.default_company_id)
            },
            {
              path: args.fetch(:object_name, '').to_s.to_camel_case,
              id: args.fetch(:id, nil)
            }
          ]
        )
      end

      def find_all
        Request.get(@client, build_url)
      end
      alias all find_all

      def find_by_id(id)
        Request.get(@client, build_url(object_id: id))
      end
      alias find find_by_id

      def where(query = '', *values)
        Request.get(@client, build_url(filter: FilterQuery.sanitize(query, values)))
      end

      def create(params = {})
        Request.post(@client, build_url, params)
      end

      def update(id, params = {})
        object = find_by_id(id).merge(params)
        Request.patch(@client, build_url(object_id: id), object[:etag], params)
      end

      def destroy(id)
        object = find_by_id(id)
        Request.delete(@client, build_url(object_id: id), object[:etag])
      end
      alias delete destroy

      def method_missing(object_name, **params)
        @object_path << {
          path: object_name.to_s.to_camel_case,
          id: params.fetch(:id, nil)
        }
        if BusinessCentral::Object.const_defined?(object_name.to_s.classify)
          klass = BusinessCentral::Object.const_get(object_name.to_s.classify)
          return klass.new(client, **params.merge!({ object_path: @object_path }))
        end
        self
      end

      def respond_to_missing?(_object_name, *_params)
        true
      end

      private

      def build_url(object_id: '', filter: '')
        URLBuilder.new(
          base_url: client.url,
          object_path: @object_path,
          object_id: object_id,
          filter: filter
        ).build
      end
    end
  end
end
