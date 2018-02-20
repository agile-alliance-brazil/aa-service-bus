# frozen_string_literal: true

RSpec.describe AgileAllianceService do
  before { WebMock.enable! }
  after { WebMock.disable! }

  describe '.check_member' do
    context 'having success in the communication' do
      context 'when the user is a member' do
        before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>1</result></data>', headers: {}) }
        it { expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_truthy }
      end

      context 'when the user is not a member' do
        before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>0</result></data>', headers: {}) }
        it { expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey }
      end
    end

    context 'having failed the communication' do
      context 'when the AA service is down' do
        before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_raise(Net::OpenTimeout) }
        it 'checks the CSV' do
          expect(File).to receive(:read).once.and_call_original
          expect(CSV).to receive(:parse).once
          expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey
        end
      end

      context 'when the service responds not found' do
        before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 404, body: '', headers: {}) }
        it 'checks the CSV' do
          expect(File).to receive(:read).once.and_call_original
          expect(CSV).to receive(:parse).once
          expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey
        end
      end

      context 'when the service responds 301 moved permanently' do
        before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/check-membership").to_return(status: 301, body: '', headers: {}) }
        it 'checks the CSV' do
          expect(File).to receive(:read).once.and_call_original
          expect(CSV).to receive(:parse).once
          expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey
        end
      end
    end
  end
end
