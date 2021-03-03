# frozen_string_literal: true

module BusinessCentral
  module Object
    class DefaultDimension < Base
      OBJECT = 'defaultDimensions'

      OBJECT_VALIDATION = {
        parent_id: {
          required: true
        },
        dimension_code: {
          maximum_length: 20
        },
        dimension_value_code: {
          maximum_length: 20
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        items
        customers
        vendors
        employees
      ].freeze

      def initialize(client, parent:, parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent,
          id: parent_id
        }
        @parent_id = parent_id
      end

      def create(params = {})
        params[:parent_id] = @parent_id
        super(params)
      end
    end
  end
end
