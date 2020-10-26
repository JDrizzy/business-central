# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesOrderLine < Base
      OBJECT = 'salesOrderLines'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        salesOrders
      ].freeze

      def initialize(client, parent: 'salesOrders', parent_id:, **args)
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
