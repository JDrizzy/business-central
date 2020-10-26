# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesInvoice < Base
      extend ObjectHelper

      OBJECT = 'salesInvoices'

      OBJECT_VALIDATION = {
        customer_purchase_order_reference: {
          maximum_length: 10
        },
        customer_number: {
          maximum_length: 20
        },
        contact_id: {
          maximum_length: 250
        },
        currency_code: {
          maximum_length: 10
        },
        email: {
          maximum_length: 80
        },
        phone: {
          maximum_length: 30
        },
        payment_terms: {
          maximum_length: 10
        },
        shipment_method: {
          maximum_length: 10
        },
        salesperson: {
          maximum_length: 20
        },
        bill_to_name: {
          maximum_length: 100
        },
        bill_to_customer_number: {
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

      navigation :sales_invoice_line
    end
  end
end
