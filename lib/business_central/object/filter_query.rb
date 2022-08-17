# frozen_string_literal: true

module BusinessCentral
  module Object
    class FilterQuery
      using Refinements::Strings

      extend URLHelper

      class << self
        def sanitize(query = '', values = [])
          return encode_url_params(query) if values.length.zero?

          query = replace_template_with_value(query, values)
          encode_url_params(query)
        end
      end
    end
  end
end
