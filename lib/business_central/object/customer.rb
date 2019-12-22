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

      def initialize(client, company_id:)
        super(client, company_id: company_id)
        @parent_path = [
          {
            path: 'companies',
            id: company_id
          }
        ]
      end
    end
  end
end
