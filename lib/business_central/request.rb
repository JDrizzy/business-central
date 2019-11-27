module BusinessCentral
  class Request
    def self.build
      begin
        request = yield
        if Response.success?(request.status)
          return Response.new(request.response.body).results
        elsif Response.deleted?(request.status)
          return true
        else
          if Response.unauthorized?(request.status)
            raise UnauthorizedException.new
          else
            raise ApiException.new("#{request.status} - API call failed")
          end
        end
      rescue OAuth2::Error => error
        if error.code['code'].present?
          case error.code['code']
            when 'Internal_CompanyNotFound'
              raise CompanyNotFoundException.new
            when 'Unauthorized'
              raise UnauthorizedException.new
            else
              raise ApiException.new(error.code['message'])
          end
        else
          raise ApiException.new(error.message)
        end
      end
    end

    def self.convert(request = {})
      result = {}
      request.each do |key, value|
        result[key.to_s.to_camel_case] = value 
      end

      return result.to_json
    end
  end
end