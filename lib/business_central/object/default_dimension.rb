module BusinessCentral
  module Object
    class DefaultDimension < Base
      OBJECT = 'defaultDimensions'.freeze

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

      OBJECT_METHODS = [
        :get,
        :post,
        :patch,
        :delete
      ].freeze

      OBJECT_PARENTS = [
        'items',
        'customers',
        'vendors',
        'employees'
      ].freeze

      def initialize(client, company_id:, parent:, parent_id:)
        raise InvalidArgumentException.new("parents allowed: #{OBJECT_PARENTS.join(', ')}") if !valid_parent?(parent)
        super(client, company_id: company_id)
        @parent_path << {
          path: parent.downcase,
          id: parent_id
        }
        @parent_id = parent_id
      end

      def create(params = {})
        params[:parent_id] = @parent_id
        super(params)
      end

      private

      def valid_parent?(parent)
        OBJECT_PARENTS.include?(parent.downcase)
      end
    end
  end
end
