# frozen_string_literal: true

module BusinessCentral
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
          path: parent,
          id: parent_id
        }
      end
    end
  end
end
