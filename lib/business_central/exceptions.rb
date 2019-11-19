module BusinessCentral

  class BusinessCentralError < StandardError; end

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
    def initialize(field, message)
      @field = field
      @message = message
    end

    def message
      "#{@field} - #{@message}"
    end
  end
end