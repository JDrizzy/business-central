# frozen_string_literal: true

module BusinessCentral
  module Object
    class Journal < Base
      extend BusinessCentral::Object::ObjectHelper

      OBJECT = 'journals'

      OBJECT_VALIDATION = {
        code: {
          maximum_length: 10
        },
        display_name: {
          maximum_length: 50
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :journal_line
    end
  end
end
