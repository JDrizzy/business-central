# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class TaxGroup < Base
      OBJECT = 'taxGroups'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
