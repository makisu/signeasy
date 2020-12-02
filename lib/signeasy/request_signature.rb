module Signeasy
  class RequestSignature
    attr_reader :owner_first_name, :owner_company, :recipients, :is_embedded_signing, :name, :is_ordered, :owner_email, :owner_last_name, :has_markers, :last_modified_time, :status, :is_in_person, :created_time, :logo, :next, :id, :owner_user_id, :aadhaar_enabled

    def initialize(raw_request_signature)
      raw_request_signature.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    class << self

      # Fetch Request Signature details
      #
      # @param rs_id [Integer] request signature id
      # @see https://docs.signeasy.com/v2.0/reference#fetch-request-signature-details
      def fetch(rs_id)
        response = Client.get(rs_path(rs_id))
        raw_request_signature = JSON.parse(response.body, symbolize_names: true)
        if response.success?
          new(raw_request_signature)
        else
          raw_request_signature
        end
      end

      # Remind Signers of Request Signatures
      #
      # @param rs_id [Integer] request signature id
      # @see https://docs.signeasy.com/v2.0/reference#remind-signers-of-request-signatures
      def remind(rs_id)
        RemindResult.new(
          Client.post(remind_path(rs_id))
        )
      end

      # Cancel Request Signatures
      #
      # @param rs_id [Integer] request signature id
      # @see https://docs.signeasy.com/v2.0/reference#cancel-request-signatures
      def cancel(rs_id)
        CancelResult.new(
          Client.post(cancel_path(rs_id))
        )
      end

      # Fetch Signing Link
      #
      # NOTE: This only works for files that are sent with embedded_signing:
      # true. Otherwise, you will get a 401 Unauthorized.
      #
      # @param rs_id [Integer] request signature id
      # @param recipient_email [String] Email of the signer, whose signing link
      #   is being requested.
      # @param redirect_url [String] URL that the user would be redirected to,
      #   once they sign the document. The pending_file_id of the signature
      #   requests will be added as a query parameter.
      # @param allow_decline [Boolean] Use this option to not allow your
      #  document signers to "decline" the signature request. In this case, they
      #  would be directly taken to the document signing screen instead of having
      #  them to accept the signature request first.
      #
      # @see https://docs.signeasy.com/v2.0/reference#fetch-signing-link-2
      def fetch_signing_url(rs_id, recipient_email:, redirect_url:, allow_decline: false)
        response = Client.post(
          signing_url_path(rs_id),
          {
            recipient_email: recipient_email,
            redirect_url: redirect_url,
            allow_decline: allow_decline
          }
        )
        UrlResult.new(response)
      end

      # Download Request Signature as PDF
      #
      # NOTE: This only works for files that are sent with embedded_signing:
      # true. Otherwise, you will get a 401 Unauthorized.
      #
      # @param rs_id [Integer] request signature id
      # @see https://docs.signeasy.com/v2.0/reference#download-request-signature-as-pdf
      def download(rs_id)
        PdfResult.new(
          Client.get(download_path(rs_id))
        )
      end

      private

      def path
        "template/rs"
      end

      def rs_path(rs_id)
        "#{path}/#{rs_id}"
      end

      def remind_path(rs_id)
        "#{rs_path(rs_id)}/remind"
      end

      def cancel_path(rs_id)
        "#{rs_path(rs_id)}/cancel"
      end

      def download_path(rs_id)
        "#{rs_path(rs_id)}/download"
      end

      def signing_url_path(rs_id)
        "#{rs_path(rs_id)}/signing/url"
      end
    end
  end
end
