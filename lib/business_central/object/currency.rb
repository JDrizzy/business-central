module BusinessCentral
  module Object
    class Currency < Base
      OBJECT = 'currencies'.freeze

      OBJECT_VALIDATION = {
        code: {
          required: true
        },
        display_name: {
          required: true,
          maximum_length: 100
        },
        symbol: {
          required: true
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
