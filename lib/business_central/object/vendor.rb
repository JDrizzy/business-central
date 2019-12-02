module BusinessCentral
  module Object
    class Vendor < Base
      OBJECT = 'vendors'.freeze

      OBJECT_VALIDATION = {
        number: {
          maximum_length: 20
        },
        display_name: {
          maximum_length: 100
        },
        phone_number: {
          maximum_length: 30
        },
        email: {
          maximum_length: 80
        },
        website: {
          maximum_length: 80
        },
        tax_registration_number: {
          maximum_length: 20
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
