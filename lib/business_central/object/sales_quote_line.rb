# frozen_string_literal: true

module BusinessCentral
  module Object
    class SalesQuoteLine < Base
      OBJECT = 'salesQuoteLines'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        salesQuotes
      ].freeze

      def initialize(client, parent: 'salesQuotes', parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent,
          id: parent_id
        }
      end
    end
  end
end
