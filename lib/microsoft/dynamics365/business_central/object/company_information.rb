# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
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
