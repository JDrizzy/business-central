# frozen_string_literal: true

module BusinessCentral
  module Object
    module URLHelper
      def encode_url_object(object)
        URI.encode(object)
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
        query.scan(/\?/).each_with_index do |_character, index|
          character_position = query =~ /\?/
          query[character_position] = odata_encode(values[index])
        end
        query
      end
    end
  end
end
