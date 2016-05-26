# frozen_string_literal: true
RSpec.describe AgileAllianceService do
  before { WebMock.enable! }
  after { WebMock.disable! }

  describe '.check_member' do
    context 'when the user is a member' do
      before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/api/").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>1</result></data>', headers: {}) }
      it { expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_truthy }
    end

    context 'when the user is not a member' do
      before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/api/").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>0</result></data>', headers: {}) }
      it { expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey }
    end

    context 'when the AA service is down' do
      before { WebMock.stub_request(:post, "#{ENV['AA_API_HOST']}/api/").to_return(status: 200, body: '<?xml version=\"1.0\" encoding=\"UTF-8\"?><data><result>0</result></data>', headers: {}) }
      it { expect(AgileAllianceService.aa_member?('foo@bar.com', 'bla')).to be_falsey }
    end
  end
end
