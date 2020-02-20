# frozen_string_literal: true

module BusinessCentral
  module Object
    class FilterQuery
      class << self
        def sanitize(query = '', values = [])
          return url_encode(query) if values.length.zero?

          query = replace_template_with_value(query, values)
          url_encode(query)
        end

        private

        def url_encode(query)
          CGI.escape(query)
        end

        def odata_encode(values, index)
          value = values[index].dup
          value.gsub!(/'/, "''") if value =~ /'/
          value.to_s
        end

        def replace_template_with_value(query, values)
          query = query.dup
          query.scan(/\?/).each_with_index do |_character, index|
            character_position = query =~ /\?/
            query[character_position] = odata_encode(values, index)
          end
          query
        end
      end
    end
  end
end
