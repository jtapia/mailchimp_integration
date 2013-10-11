require 'spec_helper'

describe MailChimpList do
  subject { described_class.new(Factories.api_key) }

  it '#subscribe calls list_subscribe on MailChimp::API instance' do
    Mailchimp::API.any_instance.should_receive(:list_subscribe)
    subject.subscribe('123', 'andrei@spreecommerce.com')
  end

  it 'return TRUE when' do
    VCR.use_cassette('processor_subscribe_success') do
      response = subject.subscribe( anything, anything, anything)
      response.should eq(true)
    end
  end

  it 'returns errors from mailchimp' do
    VCR.use_cassette('processor_subscribe_invalid_email') do
      response = subject.subscribe( anything, anything, anything)
      response.should be_kind_of(Hash)
    end
  end
end
