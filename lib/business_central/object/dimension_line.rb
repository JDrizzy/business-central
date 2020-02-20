# frozen_string_literal: true

module BusinessCentral
  module Object
    class DimensionLine < Base
      OBJECT = 'dimensionLines'

      OBJECT_VALIDATION = {
        parent_id: {
          required: true
        },
        code: {
          maximum_length: 20
        },
        display_name: {
          maximum_length: 30
        },
        value_id: {
          required: true
        },
        value_code: {
          maximum_length: 20
        },
        value_display_name: {
          maximum_length: 50
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
