# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesOrder < Base
      extend ObjectHelper

      OBJECT = 'salesOrders'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :sales_order_line
    end
  end
end
