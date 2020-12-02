require 'spec_helper'

RSpec.describe Signeasy::Template do
  describe '.fetch' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'fetches template details', { vcr: { record: :once, match_requests_on: %i[method] } } do
      template = described_class.fetch(4205749)
      expect(template).to be_a Signeasy::Template
    end
  end
  describe '.list' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'returns a list of Templates', { vcr: { record: :once, match_requests_on: %i[method] } } do
      templates = described_class.list
      expect(templates).to all be_a(Signeasy::Template)
    end
  end
  describe '.request_signature' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'sends a request signature given template_id', { vcr: { record: :once, match_requests_on: %i[method] } } do
      pending_file = described_class.request_signature(
        4205749,
        recipients: [ { first_name: 'Xavi', last_name: 'Ablaza', email: 'xlablaza@gmail.com', role_id: 1 } ],
        cc: [ { email: 'xavi@makisu.co' } ],
        name: 'Demo Contract 3',
        message: 'Please sign this demo contract'
      )
      expect(pending_file).to be_a Signeasy::PendingFile
    end
    it 'sends a request signature with embedded_signing on', { vcr: { record: :once, match_requests_on: %i[method] } } do
      pending_file = described_class.request_signature(
        4205749,
        recipients: [ { first_name: 'Xavi', last_name: 'Ablaza', email: 'xlablaza@gmail.com', role_id: 1 } ],
        cc: [ { email: 'xavi@makisu.co' } ],
        name: 'Demo Contract with Embedded Signing',
        message: 'Please sign this demo contract',
        embedded_signing: true
      )
      expect(pending_file).to be_a Signeasy::PendingFile
    end
    it 'returns a pending file with an integer id', { vcr: { record: :once, match_requests_on: %i[method] } } do
      pending_file = described_class.request_signature(
        4205749,
        recipients: [ { first_name: 'Xavi', last_name: 'Ablaza', email: 'xlablaza@gmail.com', role_id: 1 } ],
        cc: [ { email: 'xavi@makisu.co' } ],
        name: 'Demo Contract with Embedded Signing',
        message: 'Please sign this demo contract',
        embedded_signing: true
      )
      expect(pending_file.id).to be_a Integer
    end

  end
  describe '.list_request_signatures' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'lists request signatures', { vcr: { record: :once, match_requests_on: %i[method] } } do
      request_signatures = described_class.list_request_signatures
      expect(request_signatures).to all be_a(Signeasy::RequestSignature)
    end
    it 'lists request signatures given a template id', { vcr: { record: :once, match_requests_on: %i[method] } } do
      request_signatures = described_class.list_request_signatures(4205749)
      expect(request_signatures).to all be_a(Signeasy::RequestSignature)
    end
  end
end
