# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesQuote < Base
      extend ObjectHelper

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
