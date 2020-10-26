# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class PurchaseInvoice < Base
      OBJECT = 'purchaseInvoices'

      OBJECT_VALIDATION = {
        number: {
          maximum_length: 20
        },
        invoice_date: {
          date: true
        },
        vendor_invoice_number: {
          maximum_length: 35
        },
        vendor_number: {
          maximum_length: 20
        },
        vendor_name: {
          maximum_length: 50
        },
        currency_code: {
          maximum_length: 10
        },
        status: {
          maximum_length: 20,
          inclusion_of: [
            'Draft',
            'In Review',
            'Open',
            'Paid',
            'Canceled',
            'Corrective. Read-Only'
          ]
        },
        payment_terms: {
          maximum_length: 10
        },
        shipment_method: {
          maximum_length: 10
        },
        pay_to_name: {
          maximum_length: 100
        },
        pay_to_contact: {
          maximum_length: 100
        },
        pay_to_vendor_number: {
          maximum_length: 20
        },
        ship_to_name: {
          maximum_length: 100
        },
        ship_to_contact: {
          maximum_length: 100
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
