# frozen_string_literal: true

module Microsoft::Dynamics365::BusinessCentral
  class WebService
    DEFAULT_URL = 'https://api.businesscentral.dynamics.com/v2.0/production/ODataV4'

    attr_reader :url, :object_url

    def initialize(client:, **options)
      @client = client
      opts = options.dup
      @url = opts.delete(:url) || DEFAULT_URL
    end

    def object(object_url = '', *values)
      if values.length.zero?
        @object_url = object_url
        return self
      end

      @object_url = Object::URLBuilder.sanitize(object_url, values)
      self
    end

    def get(query = '', *values)
      raise InvalidObjectURLException if @object_url.to_s.blank?

      Object::Request.get(
        @client,
        build_url(
          filter: Object::FilterQuery.sanitize(query, values)
        )
      )
    end

    def post(params = {})
      raise InvalidObjectURLException if @object_url.to_s.blank?

      Object::Request.post(
        @client,
        build_url,
        params
      )
    end

    def patch(params = {})
      raise InvalidObjectURLException if @object_url.to_s.blank?

      object = get
      Object::Request.patch(
        @client,
        build_url,
        object[:etag],
        params
      )
    end

    def delete
      raise InvalidObjectURLException if @object_url.to_s.blank?

      object = get
      Object::Request.delete(
        @client,
        build_url,
        object[:etag]
      )
    end

    private

    def build_url(filter: '')
      Object::URLBuilder.new(
        base_url: "#{@url}/#{@object_url}",
        filter: filter
      ).build
    end
  end
end
