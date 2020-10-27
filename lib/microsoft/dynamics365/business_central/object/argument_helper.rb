# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    module ArgumentHelper
      def id(argument)
        return @id if instance_variable_defined?('@id') && !@id.nil?
        return argument.fetch(:id, '') if !argument.nil?

        nil
      end

      def company_id(argument)
        return @client.default_company_id if !@client.default_company_id.nil?
        return @company_id if instance_variable_defined?('@company_id') && !@company_id.nil?
        return argument.fetch(:company_id, '') if !argument.nil?

        nil
      end
    end
  end
end
