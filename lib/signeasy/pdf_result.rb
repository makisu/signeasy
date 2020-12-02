module Signeasy
  class PdfResult
    attr_reader :pdf_data, :error_message, :error_code

    def initialize(response)
      @response = response
      if @response.status == 200
        pdf_data = @response.body
      else
        body = JSON.parse(@response.body, symbolize_names: true)
        @error_message = body[:message]
        @error_code = body[:error_code]
      end
    end

    def success?
      @response.status == 200
    end
  end
end
