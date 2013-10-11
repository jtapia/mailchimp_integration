require 'spec_helper'

describe Processor do

  it '#subscribe_to_list returns success notification' do
    VCR.use_cassette('processor_subscribe_success') do
      response = described_class.subscribe_to_list(
        Factories.api_key,
        Factories.list_id,
        "andrei@spreecommerce.com"
      )

      response.should be_kind_of(Hash)
      response.should have_key(:notifications)
      response[:notifications].first[:level].should eq("info")
      response[:notifications].first[:subject].should match("Successfully Subscribed")
      response[:notifications].first[:description].should match("Successfully Subscribed")
    end
  end

  it '#subscribe_to_list returns error notification' do
    VCR.use_cassette('processor_subscribe_invalid_email') do
      expect {  
        response = described_class.subscribe_to_list(
          Factories.api_key,
          Factories.list_id,
          "andrei@spreecommerce.com"
        )
      }.to raise_error MailChimpError
    end
  end

  it '#subscribe_to_list returns success notification' do
    VCR.use_cassette('processor_subscribe_invalid_already_subscribed') do
      response = described_class.subscribe_to_list(
        Factories.api_key,
        Factories.list_id,
        "andrei@spreecommerce.com"
      )

      response.should be_kind_of(Hash)
      response.should have_key(:notifications)
      response[:notifications].first[:level].should eq("info")
      response[:notifications].first[:subject].should match("Successfully Subscribed")
      response[:notifications].first[:description].should match("Successfully Subscribed")
    end
  end
end
