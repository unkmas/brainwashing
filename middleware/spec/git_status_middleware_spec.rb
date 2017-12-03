require_relative '../../spec_helper'
require_relative '../git_status_middleware'

describe GitStatusMiddleware do
  let(:middleware) { described_class.new(app) }
  let(:app) do
    double :app, call: [
      200, {}, [app_body]
    ]
  end

  let(:body) { middleware.call({}).last }

  context 'when body is html' do
    let(:app_body) { '<html><body></body></html>' }

    before do
      allow(middleware).to receive(:`).with('git rev-parse --abbrev-ref HEAD').and_return(current_branch)
    end

    context 'when branch is defined' do
      let(:current_branch) { 'master' }
      it { expect(body).to contain_exactly("<html><body><div class='current-branch'>master</div></body></html>") }
    end

    context 'when branch is not defined' do
      let(:current_branch) { '' }
      it { expect(body).to contain_exactly("<html><body><div class='current-branch'>Use git, little bitch</div></body></html>") }
    end
  end

  context 'when body is not html' do
    let(:app_body) { 'Some plain text' }
    it { expect(body).to contain_exactly('Some plain text') }
  end
end