# frozen_string_literal: true

module BusinessCentral
  module Object
    class RetainedEarningStatement < Base
      OBJECT = 'retainedEarningsStatement'

      OBJECT_METHODS = %i[
        get
      ].freeze
    end
  end
end
