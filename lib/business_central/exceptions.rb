module BusinessCentral

  class BusinessCentralError < StandardError; end

  class InvalidClientException < BusinessCentralError
    def message
      'Invalid application setup'
    end
  end

  class ApiException < BusinessCentralError
    def initialize(message)
      @message = message
    end

    def message
      @message
    end
  end

  class CompanyNotFoundException < BusinessCentralError
    def message
      'Company not found'
    end
  end

  class UnauthorizedException < BusinessCentralError
    def message
      'Unauthorized - The credentials provided are incorrect'
    end
  end

  class InvalidObjectException < BusinessCentralError
    def initialize(errors)
      @errors = errors
    end

    def message
      @errors.each do |error|
        "#{error[:field]} - #{error[:message]}"
      end
    end
  end
end