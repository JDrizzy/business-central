# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class CustomerPayment < Base
      OBJECT = 'customerPayments'

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

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
