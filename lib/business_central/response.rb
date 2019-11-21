module BusinessCentral
  class Response
    attr_reader :results

    def initialize(response)
      @results = nil
      @response = JSON.parse(response)
      if @response.has_key?('value')
        @response = @response['value']
      end
      process
    end

    def self.success?(status)
      status == 200 || status == 201
    end

    def self.unauthorized?(status)
      status == 401
    end

    private

    def process
      if @response.is_a?(Array)
        @results = []
        @response.each do |data|
          @results << convert(data)
        end
      elsif @response.is_a?(Hash)
        @results = convert(@response)
      end
    end

    def convert(data)
      result = {}    
      data.each do |key, value|
        if key == "@odata.etag"
          result[:etag] = value
        elsif key == "@odata.context"
          result[:context] = value
        elsif value.is_a?(Hash)
          result[key.to_snake_case.to_sym] = convert(value)
        else
          result[key.to_snake_case.to_sym] = value
        end
      end

      return result
    end
  end
end