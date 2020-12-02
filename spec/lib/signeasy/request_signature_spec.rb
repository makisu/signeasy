require 'spec_helper'

RSpec.describe Signeasy::RequestSignature do
  describe '.fetch' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'fetches request signature details', { vcr: { record: :once, match_requests_on: %i[method] } } do
      request_signature = described_class.fetch(1652096)
      expect(request_signature).to be_a Signeasy::RequestSignature
    end
  end
  describe '.remind' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'reminds signers of request signatures', { vcr: { record: :once, match_requests_on: %i[method] } } do
      remind_result = described_class.remind(1652302)
      expect(remind_result.success?).to eq true
      expect(remind_result.error_message).to be_nil
      expect(remind_result.error_code).to be_nil
    end
    it 'returns an error if recipient cannot be reminded', { vcr: { record: :once, match_requests_on: %i[method] } } do
      remind_result = described_class.remind(1652096)
      expect(remind_result.success?).to eq false
      expect(remind_result.error_message).to eq 'No recipient available to remind'
      expect(remind_result.error_code).to eq 'recipient_unavailable'
    end
  end
  describe '.cancel' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'cancels a request signature', { vcr: { record: :once, match_requests_on: %i[method] } } do
      cancel_result = described_class.cancel(1652302)
      expect(cancel_result.success?).to eq true
      expect(cancel_result.error_message).to be_nil
      expect(cancel_result.error_code).to be_nil
    end
    it 'returns an error if request signature cannot be cancelled', { vcr: { record: :once, match_requests_on: %i[method] } } do
      cancel_result = described_class.cancel(1652096)
      expect(cancel_result.success?).to eq false
      expect(cancel_result.error_message).to eq 'Unauthorized'
      expect(cancel_result.error_code).to eq 'unauthorized_resource'
    end
  end
  describe '.fetch_signing_url' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'fetches the signing link of a pending file sent with embedded signing', { vcr: { record: :once, match_requests_on: %i[method] } } do
      url_result = described_class.fetch_signing_url(1653475, recipient_email: 'xlablaza@gmail.com', redirect_url: 'https://makisu.co', allow_decline: true)
      expect(url_result.success?).to eq true
      expect(url_result.url).to be_a String
    end
    it 'returns an error when fetching a pending file without embedded signing', { vcr: { record: :once, match_requests_on: %i[method] } } do
      url_result = described_class.fetch_signing_url(1653277, recipient_email: 'xlablaza@gmail.com', redirect_url: 'https://makisu.co', allow_decline: true)
      expect(url_result.success?).to eq false
      expect(url_result.error_message).to eq 'Unauthorized'
      expect(url_result.error_code).to eq 'unauthorized_resource'
    end
  end
  describe '.download' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
      end
    end
    it 'returns pdf data', { vcr: { record: :once, match_requests_on: %i[method] } } do
      pdf_result = described_class.download(1653475)
      expect(pdf_result.success?).to eq true
      expect(pdf_result.error_message).to be_nil
      expect(pdf_result.error_code).to be_nil
    end
    it 'returns an error when downloading a pending file without embedded signing', { vcr: { record: :once, match_requests_on: %i[method] } } do
      pdf_result = described_class.download(1653277)
      expect(pdf_result.success?).to eq false
      expect(pdf_result.error_message).to eq 'Unauthorized'
      expect(pdf_result.error_code).to eq 'unauthorized_resource'
    end
  end
end
