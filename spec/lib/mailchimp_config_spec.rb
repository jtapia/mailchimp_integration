require 'spec_helper'

describe MailChimpConfig do
  let(:api_key) { '448fda9e4c6b13366736ed6646a7fc6d-us7' }

  it 'creates valid object' do
    instance = described_class.new(api_key)
    instance.mailchimp.should be_kind_of(Mailchimp::API)
    instance.mailchimp.api_key.should eq(api_key)
  end

  it 'raises error without API key' do
    expect {
      instance = described_class.new('')
    }.to raise_error AuthorizationError
  end
end
