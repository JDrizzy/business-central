# frozen_string_literal: true

module BusinessCentral
  module Object
    module ObjectHelper
      include ArgumentHelper

      def object(object_name, *_params)
        define_method(object_name) do |argument = nil|
          object = "@#{object_name}_cache".to_sym
          if argument.nil?
            if !instance_variable_defined?(object)
              instance_variable_set(
                object,
                BusinessCentral::Object.const_get(
                  object_name.to_s.to_camel_case(true).to_s.to_sym
                ).new(self, argument)
              )
            else
              instance_variable_get(object)
            end
          else
            instance_variable_set(
              object,
              BusinessCentral::Object.const_get(
                object_name.to_s.to_camel_case(true).to_s.to_sym
              ).new(self, **argument)
            )
          end
        end
      end

      def navigation(object_name, *_params)
        define_method(object_name) do |argument = nil|
          object = "@#{object_name}_cache".to_sym
          instance_variable_set(
            object,
            BusinessCentral::Object.const_get(object_name.to_s.to_camel_case(true).to_s.to_sym).new(
              client,
              company_id: company_id(argument),
              parent: self.class.const_get(:OBJECT),
              parent_id: id(argument)
            )
          )
        end
      end
    end
  end
end
