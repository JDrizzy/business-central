module BusinessCentral
  module Object
    class FilterQuery
      class << self
        def sanitize(query = '', values = [])
          return url_encode(query) if values.length == 0
          query = replace_template_with_value(query, values)
          url_encode(query)
        end

        private

        def url_encode(query)
          CGI::escape(query)
        end

        def odata_encode(values, index)
          values[index].gsub!(/'/, "''") if values[index] =~ /'/
          values[index].to_s
        end

        def replace_template_with_value(query, values)
          query.scan(/\?/).each_with_index do |character, index|
            character_position = query =~ /\?/
            query[character_position] = odata_encode(values, index)
          end
          query
        end
      end
    end
  end
end