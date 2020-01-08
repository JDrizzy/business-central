module BusinessCentral
  module Object
    class Company < Base
      OBJECT = 'companies'.freeze

      OBJECT_METHODS = [
        :get
      ].freeze

      def initialize(client, args)
        super(client)
        @parent_path = []
      end
    end
  end
end