# frozen_string_literal: true

module BusinessCentral
  module Object
    class SalesOrder < Base
      extend BusinessCentral::Object::ObjectHelper

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
