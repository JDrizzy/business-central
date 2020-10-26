# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class SalesCreditMemo < Base
      extend ObjectHelper

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
