# frozen_string_literal: true

module BusinessCentral
  class BusinessCentralError < StandardError; end

  class ApiException < BusinessCentralError
    def initialize(message)
      @message = message
      super
    end

    attr_reader :message
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

  class NotFoundException < BusinessCentralError
    def message
      'Not Found - The URL provided cannot be found'
    end
  end

  class InvalidObjectURLException < BusinessCentralError
    def message
      'Object URL missing for request'
    end
  end

  class InvalidClientException < BusinessCentralError
    def message
      'Invalid client setup'
    end
  end

  class InvalidGrantException < BusinessCentralError
    def initialize(error_message)
      @error_message = error_message
      super
    end

    attr_reader :error_message

    def message
      'The provided grant has expired due to it being revoked, a fresh auth token is needed'
    end
  end
end
