# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesInvoiceLine < Base
      OBJECT = 'salesInvoiceLines'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        salesInvoices
      ].freeze

      def initialize(client, parent: 'salesInvoices', parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent.downcase,
          id: parent_id
        }
      end
    end
  end
end
