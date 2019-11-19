module BusinessCentral
  class Base
    attr_reader :client,
                :company_id,
                :parent_path,
                :path

    attr_accessor :data

    def initialize(client, company_id = nil)
      @client = client
      @company_id = company_id
    end

    protected

    def get(path, params = {})
      request(path, params) do
        @client.access_token.get(
          path,
          params: params,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        )
      end
    end

    def post(path, params = {})
      request(path, params) do
        @client.access_token.post(
          path,
          body: convert_request(params),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        )
      end
    end

    def build_url(parent_path: [], child_path: '', child_id: '', filter: '')
      url_builder(parent_path, child_path, child_id, filter)
    end

    def valid_object?(object_validation, params = {})
      object_validation.each do |key, value|
        if params.has_key?(key)
          value.each do |validation_key, validation_value|
            if validation_key == :required && validation_value == true && params[key].blank?
              raise InvalidObjectException.new(key, 'is a required field')
            elsif validation_key == :maximum_length && params[key].length > validation_value
              raise InvalidObjectException.new(key, "has exceeded the maximum length #{validation_value}")
            elsif validation_key == :inclusion_of && !validation_value.includes?(params[key])
              raise InvalidObjectException.new(key, "is not a #{validation_value.join(', ')}")
            end
          end
        end
      end
    end

    private

    def url_builder(parent_path = [], child_path = '', child_id = '', filter = '')
      url = @client.url
      url += parent_path.map { |parent| "/#{parent[:path]}(#{parent[:id]})" }.join('') if !parent_path.empty?
      url += "/#{child_path}" if !child_path.blank?
      url += "(#{child_id})" if !child_id.blank?
      url += "?$filter=#{filter}" if !filter.blank?
      return url
    end

    def request(path, params = {})
      begin
        request = yield
        if successful_response?(request.status)
          response = JSON.parse(request.response.body)
          if response.has_key?('value')
            @data = handle_response(response['value'])
          else
            @data = handle_response(response)
          end
        else
          if request.status == 401
            raise UnauthorizedException.new
          else
            raise ApiException.new("#{request.status} - API call failed")
          end
        end
      rescue OAuth2::Error => error
        handle_error(error)
      end
    end

    def successful_response?(status)
      status == 200 || status == 201
    end

    def convert_request(request = {})
      result = {}
      request.each do |key, value|
        result[key.to_s.camelize(:lower)] = value 
      end

      return result.to_json
    end

    def convert_response(response = {})
      result = {}    
      response.each do |key, value|
        if key == "@odata.etag"
          result[:etag] = value
        elsif key == "@odata.context"
          result[:context] = value
        elsif value.is_a?(Hash)
          result[key.underscore.to_sym] = convert_response(value)
        else
          result[key.underscore.to_sym] = value
        end
      end

      return result
    end

    def handle_response(response)
      results = nil
      if response.is_a?(Array)
        results = []
        response.each do |data|
          results << convert_response(data)
        end
      elsif response.is_a?(Hash)
        results = convert_response(response)
      end

      return results
    end

    def handle_error(error)
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
end