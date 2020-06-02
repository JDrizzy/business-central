# frozen_string_literal: true

module BusinessCentral
  module Object
    class VendorPurchase < Base
      OBJECT = 'vendorPurchases'

      OBJECT_METHODS = %i[
        get
      ].freeze
    end
  end
end
