module BusinessCentral
  module Object
    class Request
      def self.get(client, url)
        build do
          https, uri = connection(url)
          request = Net::HTTP::Get.new(uri)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          if client.access_token
            request['Authorization'] = "Bearer #{client.access_token.token}"
          else
            request.basic_auth(client.username, client.password)
          end
          https.request(request)
        end
      end

      def self.post(client, url, params = {})
        build do
          https, uri = connection(url)
          request = Net::HTTP::Post.new(uri)
          request.body = convert(params)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          if client.access_token
            request['Authorization'] = "Bearer #{client.access_token.token}"
          else
            request.basic_auth(client.username, client.password)
          end
          https.request(request)
        end
      end

      def self.patch(client, url, etag, params = {})
        build do
          https, uri = connection(url)
          request = Net::HTTP::Patch.new(uri)
          request.body = convert(params)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          request['If-Match'] = etag
          if client.access_token
            request['Authorization'] = "Bearer #{client.access_token.token}"
          else
            request.basic_auth(client.username, client.password)
          end
          https.request(request)
        end
      end

      def self.delete(client, url, etag)
        build do
          https, uri = connection(url)
          request = Net::HTTP::Delete.new(uri)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          request['If-Match'] = etag
          if client.access_token
            request['Authorization'] = "Bearer #{client.access_token.token}"
          else
            request.basic_auth(client.username, client.password)
          end
          https.request(request)
        end
      end

      private

      def self.connection(url)
        uri = URI(url)
        https = Net::HTTP.new(uri.host, uri.port);
        https.use_ssl = true
        return https, uri
      end

      def self.convert(request = {})
        result = {}
        request.each do |key, value|
          result[key.to_s.to_camel_case] = value 
        end

        return result.to_json
      end

      def self.build
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
              if response[:error][:code].present?
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