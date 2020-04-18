# frozen_string_literal: true

module BusinessCentral
  module Object
    class PaymentMethod < Base
      OBJECT = 'paymentMethods'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
