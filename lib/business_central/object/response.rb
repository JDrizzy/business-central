# frozen_string_literal: true

module BusinessCentral
  module Object
    class Response
      class << self
        def success?(status)
          [200, 201].include?(status)
        end

        def success_no_content?(status)
          status == 204
        end

        def unauthorized?(status)
          status == 401
        end

        def not_found?(status)
          status == 404
        end
      end

      attr_reader :results

      def initialize(response)
        @results = nil
        return if response.blank?

        @response = JSON.parse(response)
        @response = @response['value'] if @response.key?('value')
        process
      end

      private

      def process
        if @response.is_a?(String)
          @results = @response
        elsif @response.is_a?(Array)
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
          if key == '@odata.etag'
            result[:etag] = value
          elsif key == '@odata.context'
            result[:context] = value
          elsif value.is_a?(Hash)
            result[key.to_snake_case.to_sym] = convert(value)
          else
            result[key.to_snake_case.to_sym] = value
          end
        end

        result
      end
    end
  end
end
