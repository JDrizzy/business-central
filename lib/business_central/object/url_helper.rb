# frozen_string_literal: true

module BusinessCentral
  module Object
    module URLHelper
      def encode_url_object(object)
        URI::RFC2396_Parser.new.escape(object)
      end

      def encode_url_params(query)
        CGI.escape(query)
      end

      def odata_encode(value)
        value = value.dup
        value.gsub!(/'/, "''") if value =~ /'/
        value.to_s
      end

      private

      def replace_template_with_value(query, values)
        query = query.dup
        return replace_template_with_hash_values(query, values) if values.first.is_a?(Hash)
        replace_template_with_array_values(query, values)
      end

      def replace_template_with_hash_values(query, values)
        values.first.each do |key, value|
          query.gsub!(/:#{key}/, odata_encode(value))
        end
        query
      end

      def replace_template_with_array_values(query, values)
        query.scan(/\?/).each_with_index do |_character, index|
          character_position = query =~ /\?/
          query[character_position] = odata_encode(values[index])
        end
        query
      end
    end
  end
end
