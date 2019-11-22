module BusinessCentral
  class PurchaseInvoice < Base
    OBJECT = 'purchaseInvoices'.freeze

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

    def initialize(client, company_id)
      @parent_path = [
        {
          path: 'companies',
          id: company_id
        }
      ]
      super(client, company_id)
    end

    def find_all
      get(build_url(parent_path: @parent_path, child_path: OBJECT))
    end

    def find_by_id(id)
      get(build_url(parent_path: @parent_path, child_path: OBJECT, child_id: id))
    end

    def where(query = '')
      get(build_url(parent_path: @parent_path, child_path: OBJECT, filter: query))
    end

    def create(params = {})
      if Validation.new(OBJECT_VALIDATION, params).valid?
        post(build_url(parent_path: @parent_path, child_path: OBJECT), params)
      end
    end
  end
end
