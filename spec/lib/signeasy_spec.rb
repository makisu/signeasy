require 'spec_helper'

RSpec.describe Signeasy do
  describe '.configure' do
    it 'allows setting of api_token' do
      Signeasy.configure { |c| c.api_token = 'my_api_token' }
      expect(Signeasy.configuration.api_token).to eq 'my_api_token'
    end
    it 'allows setting of client_id' do
      Signeasy.configure { |c| c.client_id = 'my_client_id' }
      expect(Signeasy.configuration.client_id).to eq 'my_client_id'
    end
  end
end
