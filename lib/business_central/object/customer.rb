module BusinessCentral
  module Object
    class Customer < Base
      OBJECT = 'customers'.freeze

      OBJECT_VALIDATION = {
        display_name: {
          required: true,
          maximum_length: 100
        },
        type: {
          inclusion_of: [
            'Company',
            'Person'
          ]
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
