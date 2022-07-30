# frozen_string_literal: true

module BusinessCentral
  module Object
    class Companies < Base
      OBJECT = 'companies'

      def initialize(client, **args)
        super(client, **args.merge!({ object_name: OBJECT }))
        @object_path = [{
          path: OBJECT,
          id: nil
        }]
      end
    end
  end
end
