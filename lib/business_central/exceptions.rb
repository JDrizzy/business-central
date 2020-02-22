# frozen_string_literal: true

module BusinessCentral
  class BusinessCentralError < StandardError; end

  class InvalidClientException < BusinessCentralError
    def message
      'Invalid client setup'
    end
  end

  class ApiException < BusinessCentralError
    def initialize(message)
      @message = message
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

  class InvalidObjectException < BusinessCentralError
    def initialize(errors)
      @errors = errors
    end

    def message
      @errors.each { |error| "#{error[:field]} - #{error[:message]}" }
    end
  end

  class NoSupportedMethod < BusinessCentralError
    def initialize(method, allowed_methods)
      @method = method
      @allowed_methods = allowed_methods
    end

    def message
      methods_allowed = @allowed_methods.join(', ')
      "#{@method} method is currently not support. Allowed methods are: #{methods_allowed}"
    end
  end

  class InvalidArgumentException < BusinessCentralError
    def initialize(message)
      @message = message
    end

    def message
      "Invalid argument entered - #{@message}"
    end
  end

  class InvalidObjectURLException < BusinessCentralError
    def message
      'Object URL missing for request'
    end
  end
end
