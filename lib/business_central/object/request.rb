module BusinessCentral
  module Object
    class Request

      def self.get(client, url)
        request(:get, client, url)
      end

      def self.post(client, url, params)
        request(:post, client, url, params: params)
      end

      def self.patch(client, url, etag, params)
        request(:patch, client, url, etag: etag, params: params)
      end

      def self.delete(client, url, etag)
        request(:delete, client, url, etag: etag)
      end

      private

      def self.request(method, client, url, etag: '', params: {})
        send do
          uri = URI(url)
          https = Net::HTTP.new(uri.host, uri.port);
          https.use_ssl = true
          request = Object.const_get("Net::HTTP::#{method.to_s.capitalize}").new(uri)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          request['If-Match'] = etag if !etag.blank?
          request.body = convert(params) if method == :post || method == :patch
          if client.access_token
            request['Authorization'] = "Bearer #{client.access_token.token}"
          else
            request.basic_auth(client.username, client.password)
          end
          https.request(request)
        end
      end

      def self.convert(request = {})
        result = {}
        request.each do |key, value|
          result[key.to_s.to_camel_case] = value 
        end

        return result.to_json
      end

      def self.send
        begin
          request = yield
          response = Response.new(request.read_body.to_s).results

          if Response.success?(request.code.to_i)
            return response
          elsif Response.deleted?(request.code.to_i)
            return true
          else
            if Response.unauthorized?(request.code.to_i)
              raise UnauthorizedException.new
            else
              if !response[:error][:code].blank?
                case response[:error][:code]
                  when  'Internal_CompanyNotFound'
                    raise CompanyNotFoundException.new
                  else
                    raise ApiException.new("#{request.code} - #{response[:error][:code]} #{response[:error][:message]}")
                end
              else
                raise ApiException.new("#{request.code} - API call failed")
              end
            end
          end
        end
      end
    end
  end
end