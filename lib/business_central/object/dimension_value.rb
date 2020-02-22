# frozen_string_literal: true

module BusinessCentral
  module Object
    class DimensionValue < Base
      OBJECT = 'dimensionValues'

      OBJECT_VALIDATION = {
        code: {
          required: true,
          maximum_length: 20
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
      ].freeze

      def initialize(client, dimension_id:, **args)
        super(client, args)
        @parent_path << {
          path: 'dimensions',
          id: dimension_id
        }
      end
    end
  end
end
