# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  module Object
    class CountryRegion < Base
      OBJECT = 'countriesRegions'

      OBJECT_VALIDATION = {
        code: {
          required: true
        },
        display_name: {
          required: true,
          maximum_length: 100
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end

