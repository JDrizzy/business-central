# frozen_string_literal: true

module BusinessCentral
  module Object
    class Employee < Base
      extend BusinessCentral::Object::ObjectHelper

      OBJECT = 'employees'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :default_dimension
      navigation :picture
    end
  end
end
