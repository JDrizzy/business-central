# frozen_string_literal: true

module BusinessCentral
  module Object
    class SalesQuote < Base
      extend BusinessCentral::Object::ObjectHelper

      OBJECT = 'salesQuotes'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :sales_quote_line
    end
  end
end
