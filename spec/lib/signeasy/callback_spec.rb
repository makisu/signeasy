require 'spec_helper'

RSpec.describe Signeasy::Callback do
  describe '.register' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
        c.client_id = CONFIG[:client_id]
      end
    end
    it 'registers a callback', { vcr: { record: :new_episodes, match_requests_on: %i[method] } } do
      response = described_class.register(
        'https://makisu.co/callback',
        events: [
          'rs.initiated',
          'rs.link_sent',
          'rs.viewed',
          'rs.signed',
          'rs.declined',
          'rs.voided',
          'rs.reminded',
          'rs.completed'
        ],
        token: 'my_custom_token'
      )
      expect(response).to be_a Signeasy::Callback
      expect(response.token).to eq 'my_custom_token'
    end
    it 'registers a callback without token', { vcr: { record: :new_episodes, match_requests_on: %i[method] } } do
      response = described_class.register(
        'https://makisu.co/callback3',
        events: [
          'rs.initiated',
          'rs.link_sent',
          'rs.viewed',
          'rs.signed',
          'rs.declined',
          'rs.voided',
          'rs.reminded',
          'rs.completed'
        ]
      )
      expect(response).to be_a Signeasy::Callback
      expect(response.token).to be_nil
    end
  end
  describe '.update' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
        c.client_id = CONFIG[:client_id]
      end
    end
    it 'updates a callback', { vcr: { record: :new_episodes, match_requests_on: %i[method] } } do
      response = described_class.update(
        'https://makisu.co/callback3',
        events: [
          'rs.initiated'
        ],
        token: 'callback3-token'
      )
      expect(response).to be_a Signeasy::Callback
      expect(response.events).to eq ['rs.initiated']
      expect(response.token).to eq 'callback3-token'
    end
  end
  describe '.list' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
        c.client_id = CONFIG[:client_id]
      end
    end
    it 'lists callbacks', { vcr: { record: :new_episodes, match_requests_on: %i[method] } } do
      response = described_class.list
      expect(response).to all be_a(Signeasy::Callback)
    end
  end
  describe '.remove' do
    before do
      Signeasy.configure do |c|
        c.api_token = CONFIG[:api_token]
        c.client_id = CONFIG[:client_id]
      end
    end
    it 'removes a callback', { vcr: { record: :new_episodes, match_requests_on: %i[method] } } do
      response = described_class.remove('https://makisu.co/callback3')
      expect(response).to eq "Successfully removed callback url: https://makisu.co/callback3"
    end
  end
end
