# frozen_string_literal: true

module BusinessCentral
  module Object
    class Customer < Base
      OBJECT = 'customers'

      OBJECT_VALIDATION = {
        display_name: {
          required: true,
          maximum_length: 100
        },
        type: {
          inclusion_of: %w[
            Company
            Person
          ]
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
