module BusinessCentral
  module Object
    class CompanyInformation < Base
      OBJECT = 'companyInformation'.freeze

      OBJECT_METHODS = [
        :get,
        :patch
      ].freeze
    end
  end
end