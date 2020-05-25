# frozen_string_literal: true

module BusinessCentral
  module Object
    class SalesCreditMemo < Base
      extend BusinessCentral::Object::ObjectHelper

      OBJECT = 'salesCreditMemos'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :sales_credit_memo_line
    end
  end
end
