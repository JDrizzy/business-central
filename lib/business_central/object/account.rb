module BusinessCentral
  module Object
    class Account < Base
      OBJECT = 'accounts'.freeze

      OBJECT_METHODS = [
        :get
      ].freeze
    end
  end
end