module Signeasy
  class Callback
    attr_reader :url, :events, :token
    def initialize(url, events, token)
      @url = url
      @events = events
      @token = token
    end
    class << self
      def register(url, events:, token: nil)
        response = Client.post(
          path,
          {
            url: url,
            events: events,
            token: token
          },
          headers: default_post_headers
        )
        raw_callback_urls = JSON.parse(response.body)
        if raw_callback_urls['callback_urls'].include?(url)
          new(url, events, token)
        end
      end

      def update(url, events:, token: nil)
        response = Client.put(
          path,
          {
            url: url,
            events: events,
            token: token
          },
          headers: default_post_headers
        )
        raw_callback_urls = JSON.parse(response.body)
        if raw_callback_urls['callback_urls'].include?(url)
          new(url, events, token)
        end
      end

      def list
        response = Client.get(path, default_get_headers)
        raw_callback_urls = JSON.parse(response.body)
        raw_callback_urls['callback_urls'].map do |callback_url|
          new(callback_url, raw_callback_urls[callback_url]['events'], raw_callback_urls[callback_url]['token'])
        end
      end

      def remove(url)
        response = Client.delete(path, {url: url}, headers: default_post_headers)
        raw_callback_urls = JSON.parse(response.body)
        unless raw_callback_urls['callback_urls'].include?(url)
          "Successfully removed callback url: #{url}"
        end
      end

      private

      def path
        'callback'
      end

      def api_token
        Signeasy.configuration.api_token
      end

      def client_id
        Signeasy.configuration.client_id
      end

      def default_get_headers
        {
          'Authorization' => "Bearer #{api_token}",
          'X-Client-Id' => client_id,
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
