require 'spec_helper'

RSpec.describe Signeasy do
  describe '.configure' do
    it 'allows setting of api_token' do
      Signeasy.configure { |c| c.api_token = 'my_api_token' }
      expect(Signeasy.configuration.api_token).to eq 'my_api_token'
    end
  end
end
