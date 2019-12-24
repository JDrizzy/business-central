module BusinessCentral
  module Object
    class CustomerPaymentJournal < Base
      OBJECT = 'customerPaymentJournals'.freeze

      OBJECT_VALIDATION = {
        code: {
          maximum_length: 10
        },
        display_name: {
          maximum_length: 50
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
