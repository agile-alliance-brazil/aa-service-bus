# frozen_string_literal: true

require_relative '../aa_service_bus.rb'

def app
  AaServiceBus
end

RSpec.describe AaServiceBus, type: :request do
  describe 'GET /' do
    before { get '/', {}, 'HTTP_AUTHORIZATION' => '' }
    it { expect(last_response.body).to include 'Welcome to the Agile Alliance Service Bus' }
  end

  describe 'GET /check_member' do
    context 'unauthenticated' do
      before { get '/check_member/foo@bar.com' }
      it { expect(last_response.status).to eq 401 }
    end

    context 'authenticated' do
      before { WebMock.enable! }
      after { WebMock.disable! }

      context 'when the AA API is up' do
        context 'and the user is a member' do
          subject(:body) { last_response.body }
          it 'responds true' do
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>1</result></data>', headers: {})
            get '/check_member/foo@bar.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_truthy
          end
        end

        context 'and the user is not a member' do
          subject(:body) { last_response.body }
          it 'responds false' do
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>0</result></data>', headers: {})
            get '/check_member/bla@xpto.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_falsey
          end
        end

        context 'and the service returned no node <result>' do
          subject(:body) { last_response.body }
          it 'responds false' do
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data></data>', headers: {})
            get '/check_member/bla@xpto.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_falsey
          end
        end
        context 'and the service returned no node <data>' do
          subject(:body) { last_response.body }
          it 'responds false' do
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?>', headers: {})
            get '/check_member/bla@xpto.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_falsey
          end
        end
      end

      context 'when the AA service is down' do
        subject(:body) { last_response.body }
        let!(:file) { File.read('./spec/fixtures/test.csv', encoding: 'ISO-8859-1:UTF-8') }
        context 'and the user is a member' do
          it 'verifies on CSV file and returns true' do
            expect(File).to receive(:read) { file }
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_raise(Net::OpenTimeout)
            get '/check_member/bla@xpto.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_truthy
          end
        end
        context 'and the user is not a member' do
          it 'verifies on CSV file and returns false' do
            expect(File).to receive(:read) { file }
            WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_raise(Net::OpenTimeout)
            get '/check_member/foo@bar.com', {}, 'HTTP_AUTHORIZATION' => ENV['AA_API_TOKEN']
            expect(last_response.status).to eq 200
            expect(JSON.parse(body)['member']).to be_falsey
          end
        end
      end
    end
  end
end
