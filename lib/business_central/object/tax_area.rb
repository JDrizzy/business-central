# frozen_string_literal: true

module BusinessCentral
  module Object
    class TaxArea < Base
      OBJECT = 'taxAreas'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
