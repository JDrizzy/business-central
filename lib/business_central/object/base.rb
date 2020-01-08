module BusinessCentral
  module Object
    class Base
      attr_reader :client,
                  :parent_path,
                  :path

      attr_writer :id, :company_id

      def initialize(client, args = {})
        @client = client
        @id = id(args)
        @company_id = company_id(args)
        @parent_path = @company_id.nil? ? [] : [
          {
            path: 'companies',
            id: @company_id
          }
        ]
      end

      def id(argument)
        return @id if !@id.nil?
        return argument.fetch(:id, '') if !argument.nil?
        return nil
      end

      def company_id(argument)
        return @client.default_company_id if !@client.default_company_id.nil?
        return @company_id if !@company_id.nil?
        return argument.fetch(:company_id, '') if !argument.nil?
        return nil
      end

      def find_all
        if method_supported?(:get)
          Request.get(@client, build_url(parent_path: @parent_path, child_path: object_name))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def find_by_id(id)
        if method_supported?(:get)
          Request.get(@client, build_url(parent_path: @parent_path, child_path: object_name, child_id: id))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def where(query = '')
        if method_supported?(:get)
          Request.get(@client, build_url(parent_path: @parent_path, child_path: object_name, filter: query))
        else
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
      end

      def create(params = {})
        if method_supported?(:post)
          if Validation.new(object_validation, params).valid?
            Request.post(@client, build_url(parent_path: @parent_path, child_path: object_name), params)
          end
        else
          raise BusinessCentral::NoSupportedMethod.new(:post, object_methods)
        end
      end

      def update(id, params = {})
        if method_supported?(:patch)
          object = find_by_id(id).merge(params)
          if Validation.new(object_validation, object).valid?
            Request.patch(@client, build_url(parent_path: @parent_path, child_path: object_name, child_id: id), object[:etag], object)
          end
        else
          raise BusinessCentral::NoSupportedMethod.new(:patch, object_methods)
        end
      end

      def destroy(id)
        if method_supported?(:delete)
          object = find_by_id(id)
          Request.delete(@client, build_url(parent_path: @parent_path, child_path: object_name, child_id: id), object[:etag])
        else
          raise BusinessCentral::NoSupportedMethod.new(:delete, object_methods)
        end
      end

      private

      def object_name
        self.class.const_get(:OBJECT)
      end

      def object_validation
        self.class.const_defined?(:OBJECT_VALIDATION) ? self.class.const_get(:OBJECT_VALIDATION) : []
      end

      def object_methods
        self.class.const_get(:OBJECT_METHODS)
      end

      def method_supported?(method)
        return true if object_methods.include?(method)
        return false
      end

      def build_url(parent_path: [], child_path: '', child_id: '', filter: '')
        url_builder(parent_path, child_path, child_id, filter)
      end

      def url_builder(parent_path = [], child_path = '', child_id = '', filter = '')
        url = @client.url
        url += parent_path.map { |parent| "/#{parent[:path]}(#{parent[:id]})" }.join('') if !parent_path.empty?
        url += "/#{child_path}" if !child_path.to_s.blank?
        url += "(#{child_id})" if !child_id.to_s.blank?
        url += "?$filter=#{CGI::escape(filter)}" if !filter.to_s.blank?
        return url
      end
    end
  end
end