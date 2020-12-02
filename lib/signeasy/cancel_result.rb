module Signeasy
  class CancelResult
    attr_reader :error_message, :error_code

    def initialize(response)
      @response = response
      if @response.status >= 400 && @response.status < 500
        body = JSON.parse(@response.body, symbolize_names: true)
        @error_message = body[:message]
        @error_code = body[:error_code]
      else
        @error_message = nil
        @error_code = nil
      end
    end

    def success?
      @response.status == 204
    end
  end
end
