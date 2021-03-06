# frozen_string_literal: true

module BusinessCentral
  module Object
    class Account < Base
      OBJECT = 'accounts'

      OBJECT_METHODS = [
        :get
      ].freeze
    end
  end
end
