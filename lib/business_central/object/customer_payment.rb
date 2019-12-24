module BusinessCentral
  module Object
    class CustomerPayment < Base
      OBJECT = 'customerPayments'.freeze

      OBJECT_VALIDATION = {
        customer_number: {
          maximum_length: 20
        },
        contact_id: {
          maximum_length: 250
        },
        posting_date: {
          date: true
        },
        document_number: {
          maximum_length: 20
        },
        external_document_number: {
          maximum_length: 20
        },
        applies_to_invoice_number: {
          maximum_length: 20
        },
        description: {
          maximum_length: 50
        },
        comment: {
          maximum_length: 250
        }
      }.freeze

      OBJECT_METHODS = [
        :get,
        :post,
        :patch,
        :delete
      ].freeze

      def initialize(client, company_id:)
        super(client, company_id: company_id)
        @parent_path = [
          {
            path: 'companies',
            id: company_id
          }
        ]
      end
    end
  end
end
