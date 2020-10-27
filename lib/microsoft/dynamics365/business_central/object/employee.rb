# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class Employee < Base
      extend ObjectHelper

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
