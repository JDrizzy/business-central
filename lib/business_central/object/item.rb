# frozen_string_literal: true

module BusinessCentral
  module Object
    class Item < Base
      OBJECT = 'items'

      OBJECT_VALIDATION = {
        number: {
          maximum_length: 20
        },
        display_name: {
          maximum_length: 100
        },
        type: {
          required: true,
          inclusive_of: %w[
            Inventory
            Service
            Non-Inventory
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

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
