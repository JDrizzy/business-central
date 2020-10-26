# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class Base
      include ArgumentHelper

      attr_reader :client, :parent_path, :path

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

      def find_all
        if !method_supported?(:get)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end

        Request.get(@client, build_url(parent_path: @parent_path, child_path: object_name))
      end
      alias all find_all

      def find_by_id(id)
        if !method_supported?(:get)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end

        Request.get(
          @client,
          build_url(
            parent_path: @parent_path,
            child_path: object_name,
            child_id: id
          )
        )
      end
      alias find find_by_id

      def where(query = '', *values)
        if !method_supported?(:get)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end

        Request.get(
          @client,
          build_url(
            parent_path: @parent_path,
            child_path: object_name,
            filter: FilterQuery.sanitize(query, values)
          )
        )
      end

      def create(params = {})
        if !method_supported?(:post)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:post, object_methods)
        end

        Validation.new(object_validation, params).valid?
        Request.post(@client, build_url(parent_path: @parent_path, child_path: object_name), params)
      end

      def update(id, params = {})
        if !method_supported?(:patch)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:patch, object_methods)
        end

        object = find_by_id(id).merge(params)
        Validation.new(object_validation, object).valid?
        Request.patch(
          @client,
          build_url(
            parent_path: @parent_path,
            child_path: object_name,
            child_id: id
          ),
          object[:etag],
          params
        )
      end

      def destroy(id)
        if !method_supported?(:delete)
          raise Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod.new(:delete, object_methods)
        end

        object = find_by_id(id)
        Request.delete(
          @client,
          build_url(
            parent_path: @parent_path,
            child_path: object_name,
            child_id: id
          ),
          object[:etag]
        )
      end

      protected

      def valid_parent?(parent)
        return true if object_parent_name.map(&:downcase).include?(parent.downcase)

        raise InvalidArgumentException, "parents allowed: #{object_parent_name.join(', ')}"
      end

      def build_url(parent_path: [], child_path: '', child_id: '', filter: '')
        URLBuilder.new(
          base_url: client.url,
          parent_path: parent_path,
          child_path: child_path,
          child_id: child_id,
          filter: filter
        ).build
      end

      private

      def object_name
        self.class.const_get(:OBJECT)
      end

      def object_validation
        if self.class.const_defined?(:OBJECT_VALIDATION)
          self.class.const_get(:OBJECT_VALIDATION)
        else
          []
        end
      end

      def object_methods
        self.class.const_get(:OBJECT_METHODS)
      end

      def object_parent_name
        self.class.const_get(:OBJECT_PARENTS)
      end

      def method_supported?(method)
        return true if object_methods.include?(method)

        false
      end
    end
  end
end
