module BusinessCentral
  class Base
    attr_reader :client,
                :company_id,
                :parent_path,
                :path,
                :data

    def initialize(client, company_id = nil)
      @client = client
      @company_id = company_id
      @data = nil
    end

    protected

    def get(path, params = {})
      @data = Request.build do
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
      @data = Request.build do
        @client.access_token.post(
          path,
          body: Request.convert(params),
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
        value.each do |validation_key, validation_value|
          if validation_key == :required && validation_value == true && params[key].to_s.blank?
            raise InvalidObjectException.new(key, 'is a required field')
          else
            if params.has_key?(key)
              if validation_key == :maximum_length && params[key].length > validation_value
                raise InvalidObjectException.new(key, "has exceeded the maximum length #{validation_value}")
              elsif validation_key == :inclusion_of && !validation_value.include?(params[key])
                raise InvalidObjectException.new(key, "is not one of #{validation_value.join(', ')}")
              end
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
  end
end