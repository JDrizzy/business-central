module BusinessCentral
  class Item < Base
    OBJECT = 'items'.freeze

    OBJECT_VALIDATION = {
      number: {
        maximum_length: 20
      },
      display_name: {
        maximum_length: 100
      },
      type: {
        required: true,
        inclusive_of: [
          'Inventory',
          'Service',
          'Non-Inventory'
        ]
      },
      item_category_code: {
        maximum_length: 20
      },
      gtin: {
        maximum_length: 14
      },
      tax_group_code: {
        maximum_length: 20
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
