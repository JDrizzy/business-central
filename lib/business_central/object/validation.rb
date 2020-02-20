# frozen_string_literal: true

module BusinessCentral
  module Object
    class Validation
      def initialize(validation_rules = [], object_params = {})
        @validation_rules = validation_rules
        @object_params = object_params
        @errors = []
      end

      def valid?
        @validation_rules.each do |rules_key, rules_value|
          rules_value.each do |validation_key, validation_value|
            if required?(validation_key, validation_value, @object_params[rules_key].to_s)
              @errors << { field: rules_key, message: 'is a required field' }
            end

            if exceeds_maximum_length?(validation_key, validation_value, @object_params[rules_key].to_s)
              @errors << { field: rules_key, message: "has exceeded the maximum length #{validation_value}" }
            end

            if not_inclusive_of?(validation_key, validation_value, @object_params[rules_key].to_s)
              @errors << { field: rules_key, message: "is not one of #{validation_value.join(', ')}" }
            end

            if date_type?(validation_key, validation_value, @object_params[rules_key])
              @errors << { field: rules_key, message: 'is not a date' }
            end
          end
        end

        raise InvalidObjectException, @errors if @errors.any?

        true
      end

      private

      def required?(validation_rule, validation_value, value)
        validation_rule == :required && validation_value == true && value.blank?
      end

      def exceeds_maximum_length?(validation_rule, validation_value, value)
        validation_rule == :maximum_length && value.length > validation_value
      end

      def not_inclusive_of?(validation_rule, validation_value, value)
        validation_rule == :inclusion_of && !validation_value.include?(value) && !value.blank?
      end

      def date_type?(validation_rule, validation_value, value)
        validation_rule == :date && validation_value == true && !value.is_a?(Date) && !value.nil?
      end
    end
  end
end
