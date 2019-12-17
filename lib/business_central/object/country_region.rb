module BusinessCentral
  module Object
    class CountryRegion < Base
      OBJECT = 'countriesRegions'.freeze

      OBJECT_VALIDATION = {
        code: {
          required: true
        },
        display_name: {
          required: true,
          maximum_length: 100
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
