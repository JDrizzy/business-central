# frozen_string_literal: true

module BusinessCentral
  module Object
    class CompanyInformation < Base
      OBJECT = 'companyInformation'

      OBJECT_METHODS = %i[
        get
        patch
      ].freeze
    end
  end
end
