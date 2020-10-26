# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesCreditMemoLine < Base
      OBJECT = 'salesCreditMemoLines'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        salesCreditMemos
      ].freeze

      def initialize(client, parent: 'salesCreditMemos', parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent.downcase,
          id: parent_id
        }
      end
    end
  end
end
