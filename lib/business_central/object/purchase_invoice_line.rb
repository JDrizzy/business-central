# frozen_string_literal: true

module BusinessCentral
  module Object
    class PurchaseInvoiceLine < Base
      OBJECT = 'purchaseInvoiceLines'

      OBJECT_VALIDATION = {
        line_type: {
          inclusion_of: [
            'Comment',
            'Account',
            'Item',
            'Resource',
            'Fixed Asset',
            'Charge'
          ]
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      def initialize(client, company_id:, purchase_invoice_id:)
        super(client, company_id: company_id)
        @parent_path << {
          path: 'purchaseInvoices',
          id: purchase_invoice_id
        }
      end
    end
  end
end
