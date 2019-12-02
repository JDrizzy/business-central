module BusinessCentral
  module Object
    class Company < Base
      OBJECT = 'companies'.freeze

      OBJECT_METHODS = [
        :get
      ].freeze
    end
  end
end