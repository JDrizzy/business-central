# frozen_string_literal: true

module BusinessCentral
  module Object
    class IncomeStatement < Base
      OBJECT = 'incomeStatement'

      OBJECT_METHODS = %i[
        get
      ].freeze
    end
  end
end
