# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class ShipmentMethod < Base
      OBJECT = 'shipmentMethods'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
