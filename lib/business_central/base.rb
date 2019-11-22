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