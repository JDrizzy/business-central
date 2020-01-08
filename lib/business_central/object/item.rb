module BusinessCentral
  module Object
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

      OBJECT_METHODS = [
        :get,
        :post,
        :patch,
        :delete
      ].freeze
    end
  end
end
