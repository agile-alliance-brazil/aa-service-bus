# frozen_string_literal: true
require_relative '../aa_service_bus.rb'

def app
  AaServiceBus
end

RSpec.describe AaServiceBus do
  describe 'GET /' do
    before { get '/' }
    it { expect(last_response.body).to include 'Welcome to the Agile Alliance Service Bus' }
  end
end
