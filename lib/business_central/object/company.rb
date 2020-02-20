# frozen_string_literal: true

module BusinessCentral
  module Object
    class Company < Base
      OBJECT = 'companies'

      OBJECT_METHODS = [
        :get
      ].freeze

      def initialize(client, _args)
        super(client)
        @parent_path = []
      end
    end
  end
end
