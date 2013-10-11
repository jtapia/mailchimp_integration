require 'spec_helper'

describe MailChimpConfig do
  it 'creates valid object' do
    instance = described_class.new(Factories.api_key)
    instance.mailchimp.should be_kind_of(Mailchimp::API)
    instance.mailchimp.api_key.should eq(Factories.api_key)
  end

  it 'raises error without API key' do
    expect {
      instance = described_class.new('')
    }.to raise_error AuthorizationError
  end
end
