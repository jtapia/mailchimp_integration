require 'spec_helper'

describe Processor do

  it '#subscribe_to_list returns success notification' do
    VCR.use_cassette('processor_subscribe_success') do
      response = described_class.subscribe_to_list(
        Factories.config.first['value'],
        Factories.config.last['value'],
        "andrei@spreecommerce.com"
      )

      response.should be_kind_of(Hash)
      response.should have_key(:notifications)
      response[:notifications].first[:level].should eq("info")
      response[:notifications].first.should have_key(:subject)
      response[:notifications].first.should have_key(:description)
    end
  end

  it '#subscribe_to_list returns error notification' do
    VCR.use_cassette('processor_subscribe_invalid_email') do
      response = described_class.subscribe_to_list(
        Factories.config.first['value'],
        Factories.config.last['value'],
        "andrei@spreecommerce.com"
      )

      response.should be_kind_of(Hash)
      response.should have_key(:notifications)
      response[:notifications].first[:level].should eq("error")
      response[:notifications].first.should have_key(:subject)
      response[:notifications].first.should have_key(:description)
    end
  end

  it '#subscribe_to_list returns success notification' do
    VCR.use_cassette('processor_subscribe_invalid_already_subscribed') do
      response = described_class.subscribe_to_list(
        Factories.config.first['value'],
        Factories.config.last['value'],
        "andrei@spreecommerce.com"
      )

      response.should be_kind_of(Hash)
      response.should have_key(:notifications)
      response[:notifications].first[:level].should eq("info")
      response[:notifications].first.should have_key(:subject)
      response[:notifications].first.should have_key(:description)
    end
  end
end
