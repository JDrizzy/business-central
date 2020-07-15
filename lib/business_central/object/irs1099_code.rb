# frozen_string_literal: true

module BusinessCentral
  module Object
    class Irs1099Code < Base
      OBJECT = 'irs1099Codes'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
