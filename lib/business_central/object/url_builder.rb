# frozen_string_literal: true

module BusinessCentral
  module Object
    class URLBuilder
      extend URLHelper

      class << self
        def sanitize(query = '', values = [])
          return encode_url_params(query) if values.length.zero?

          query = replace_template_with_value(query, values)
          encode_url_object(query)
        end
      end

      def initialize(base_url:, object_path: [], object_id: '', object_code: '', filter: '')
        @base_url = base_url.to_s
        @object_path = object_path || []
        @object_id = object_id.to_s
        @object_code = object_code.to_s
        @filter = filter.to_s
      end

      def build
        url = @base_url
        url += build_parent_path
        url += build_child_path
        url += build_filter
        url
      end

      private

      def build_parent_path
        return '' if @object_path.empty?

        @object_path.map do |parent|
          if !parent[:id].nil?
            "/#{parent[:path]}(#{parent[:id]})"
          else
            "/#{parent[:path]}"
          end
        end.join('')
      end

      def build_child_path
        url = ''
        url += "(#{@object_id})" if @object_id.present?
        url += "('#{odata_encode(@object_code)}')" if @object_code.present?
        url
      end

      def build_filter
        url = ''
        url += "?$filter=#{@filter}" if @filter.present?
        url
      end
    end
  end
end
