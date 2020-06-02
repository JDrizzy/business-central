# frozen_string_literal: true

module BusinessCentral
  module Object
    class UnitsOfMeasure < Base
      OBJECT = 'unitsOfMeasure'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
