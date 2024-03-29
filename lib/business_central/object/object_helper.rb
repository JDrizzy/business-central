# frozen_string_literal: true

module BusinessCentral
  module Object
    module ObjectHelper
      using Refinements::Strings

      def method_missing(object_name, **params)
        if BusinessCentral::Object.const_defined?(object_name.to_s.to_class_sym)
          klass = BusinessCentral::Object.const_get(object_name.to_s.to_class_sym)
          klass.new(self, **params)
        else
          BusinessCentral::Object::Base.new(self, **params.merge!({ object_name: object_name }))
        end
      end

      def respond_to_missing?(_object_name, _include_all)
        true
      end
    end
  end
end
