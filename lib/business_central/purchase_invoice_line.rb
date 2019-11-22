module BusinessCentral
  class PurchaseInvoiceLine < Base
    OBJECT = 'purchaseInvoiceLines'.freeze

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

    def initialize(client, company_id, purchase_invoice_id)
      @parent_path = [
        {
          path: 'companies',
          id: company_id
        },
        {
          path: 'purchaseInvoices',
          id: purchase_invoice_id
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
