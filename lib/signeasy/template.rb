module Signeasy
  class Template
    attr_reader :created_time, :dirty, :hash, :id, :is_ordered, :is_owned, :is_public, :is_shared, :link, :message, :metadata, :modified_time, :name

    def initialize(raw_template)
      raw_template.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    class << self
      ## Fetch template details for a single template
      #
      # @param template_id [Integer]
      # @see https://docs.signeasy.com/v2.0/reference#fetch-template-details
      def fetch(template_id)
        response = Client.get(template_path(template_id))
        raw_template = JSON.parse(response.body, symbolize_names: true)
        if response.success?
          wrap_raw_template(raw_template)
        else
          raw_template
        end
      end

      ## List all templates
      #
      # @see https://docs.signeasy.com/v2.0/reference#list-templates
      def list
        response = Client.get(path)
        raw_templates = JSON.parse(response.body, symbolize_names: true)
        if response.success?
          raw_templates.map do |raw_template|
            wrap_raw_template(raw_template)
          end
        else
          raw_templates
        end
      end

      ## Send Request Signature using Template
      #
      # @param template_id [Integer]
      # @param recipients [Array<Hash>] each recipient is a Hash (e.g. {
      #   first_name: 'Juan', last_name: 'Dela Cruz', email: 'juan@example.com',
      #   role_id: 1 })
      # @param name [String] recipient name
      # @param message [String] message to send to the recipient
      # @param cc [Array<Hash>] each element in cc is a Hash (e.g. { email:
      #   'founder@example.com' })
      # @param embedded_signing [Boolean] If this signature request should be
      #   enabled for use in embedded signing. Enabling this suppresses all emails
      #   that the signers receive, including the emails with links to sign the
      #   document.
      # @param is_ordered [Boolean] Flag indicating if the template was
      #   selected to be used in sequential or parallel signing. false for
      #   parallel signing; true for sequential signing
      # @see https://docs.signeasy.com/v2.0/reference#fetch-template-details
      def request_signature(template_id, recipients:, name:, message:, cc: [], embedded_signing: false, is_ordered: false)
        response = Client.post(
          request_signature_path(template_id),
          {
            recipients: recipients,
            name: name,
            message: message,
            cc: cc,
            embedded_signing: embedded_signing,
            is_ordered: is_ordered
          }
        )
        raw_pending_file = JSON.parse(response.body, symbolize_names: true)
        if response.success?
          PendingFile.new(raw_pending_file[:pending_file_id])
        else
          raw_pending_file
        end
      end

      # List request signatures via templates
      # @param template_id [Integer] template id that you want to scope request
      #   signatures to
      # @see https://docs.signeasy.com/v2.0/reference#list-request-signatures-via-templates
      def list_request_signatures(template_id=nil)
        response = Client.get(request_signatures_path(template_id))
        raw_request_signatures = JSON.parse(response.body, symbolize_names: true)
        raw_request_signatures[:files].map do |raw_request_signature|
          RequestSignature.new(raw_request_signature)
        end
      end

      def fetch_signed_file(signed_file_id)
        response = Client.get(signed_file_path(signed_file_id))
      end

      private

      def path
        "template"
      end

      def template_path(template_id)
        "#{path}/#{template_id}"
      end

      def request_signatures_path(template_id=nil)
        return "#{path}/rs" if template_id.nil?

        "#{path}/#{template_id}/rs"
      end

      def request_signature_path(template_id)
        "#{template_path(template_id)}/rs"
      end

      def signed_file_path(signed_file_id)
        "#{path}/rs/signed/#{signed_file_id}"
      end

      def wrap_raw_template(raw_template)
        Template.new(raw_template)
      end
    end
  end
end
