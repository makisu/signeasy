require 'faraday'

module Signeasy
  class Client
    class << self
      def get(path, headers = default_get_headers, params: {})
        response = connection(headers).get(path) do |req|
          params.each do |k, v|
            req.params[k.to_s] = v
          end
        end
      end

      def post(path, body = {}, headers: default_post_headers)
        response = connection(headers).post(path) do |req|
          req.body = body.to_json if body.present?
        end
      end

      def put(path, body = {}, headers: default_post_headers)
        response = connection(headers).put(path) do |req|
          req.body = body.to_json if body.present?
        end
      end

      def delete(path, body = {}, headers: default_post_headers)
        response = connection(headers).delete(path) do |req|
          req.body = body.to_json if body.present?
        end
      end

      private

      def connection(headers = default_get_headers)
        Faraday.new(
          url: base_url,
          headers: headers
        )
      end

      def base_url
        'https://api.signeasy.com/v2'
      end

      def url(path)
        "#{base_url}/#{path}"
      end

      def api_token
        Signeasy.configuration.api_token
      end

      def default_get_headers
        {
          'Authorization' => "Bearer #{api_token}"
        }
      end

      def default_post_headers
        default_get_headers.merge!({
          'Content-Type' => 'application/json'
        })
      end
    end
  end
end
