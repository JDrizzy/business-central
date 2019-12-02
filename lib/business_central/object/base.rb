module BusinessCentral
  module Object
    class Base
      attr_reader :client,
                  :company_id,
                  :parent_path,
                  :path,
                  :errors

      def initialize(client, args = {})
        @client = client
        @company_id = args[:company_id] if !args.nil?
        @parent_path = []
        @path = ''
        @errors = []
      end

      def find_all
        if method_supported?(:get)
          get(build_url(parent_path: @parent_path, child_path: object_name))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def find_by_id(id)
        if method_supported?(:get)
          get(build_url(parent_path: @parent_path, child_path: object_name, child_id: id))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def where(query = '')
        if method_supported?(:get)
          get(build_url(parent_path: @parent_path, child_path: object_name, filter: query))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def create(params = {})
        if method_supported?(:patch)
          if Validation.new(object_validation, params).valid?
            post(build_url(parent_path: @parent_path, child_path: object_name), params)
          end
        else
          raise BusinessCentral::NoSupportedMethod.new(:post, object_methods)
        end
      end

      def update(id, params = {})
        if method_supported?(:patch)
          object = find_by_id(id)
          if Validation.new(object_validation, params).valid?
            patch(build_url(parent_path: @parent_path, child_path: object_name, child_id: id), object[:etag], params)
          end
        else
          raise BusinessCentral::NoSupportedMethod.new(:patch, object_methods)
        end
      end

      def destroy(id)
        if method_supported?(:delete)
          object = find_by_id(id)
          delete(build_url(parent_path: @parent_path, child_path: object_name, child_id: id), object[:etag])
        else
          raise BusinessCentral::NoSupportedMethod.new(:delete, object_methods)
        end
      end

      private

      def object_name
        self.class.const_get(:OBJECT)
      end

      def object_validation
        self.class.const_get(:OBJECT_VALIDATION)
      end

      def object_methods
        self.class.const_get(:OBJECT_METHODS)
      end

      def method_supported?(method)
        return true if object_methods.include?(method)
        return false
      end

      def get(path, params = {})
        Request.build do
          @client.access_token.get(
            path,
            params: params,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            }
          )
        end
      end

      def post(path, params = {})
        Request.build do
          @client.access_token.post(
            path,
            body: Request.convert(params),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            }
          )
        end
      end

      def patch(path, etag, params = {})
        Request.build do
          @client.access_token.patch(
            path,
            body: Request.convert(params),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'If-Match': etag
            }
          )
        end
      end

      def delete(path, etag)
        Request.build do
          @client.access_token.delete(
            path,
            body: {},
            headers: {
              'If-Match': etag
            }
          )
        end
      end

      def build_url(parent_path: [], child_path: '', child_id: '', filter: '')
        url_builder(parent_path, child_path, child_id, filter)
      end

      def url_builder(parent_path = [], child_path = '', child_id = '', filter = '')
        url = @client.url
        url += parent_path.map { |parent| "/#{parent[:path]}(#{parent[:id]})" }.join('') if !parent_path.empty?
        url += "/#{child_path}" if !child_path.blank?
        url += "(#{child_id})" if !child_id.blank?
        url += "?$filter=#{filter}" if !filter.blank?
        return url
      end
    end
  end
end