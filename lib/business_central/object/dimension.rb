# frozen_string_literal: true

module BusinessCentral
  module Object
    class Dimension < Base
      OBJECT = 'dimensions'

      OBJECT_VALIDATION = {
        code: {
          required: true,
          maximum_length: 20
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
      ].freeze
    end
  end
end
