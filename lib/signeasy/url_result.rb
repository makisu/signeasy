module Signeasy
  class UrlResult
    attr_reader :url, :error_message, :error_code

    def initialize(response)
      @response = response
      body = JSON.parse(@response.body, symbolize_names: true)
      @url = body[:url]
      @error_message = body[:message]
      @error_code = body[:error_code]
    end

    def success?
      @response.status == 200
    end
  end
end
