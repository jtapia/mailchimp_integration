require 'spec_helper'

describe MailChimpError do
  subject { described_class.new( {"error" => "Invalid Email Address: spree@example.com", "code" => 502} ) }

  it 'creates valid object' do
    subject.code.should eq(502)
    subject.msg.should eq("Invalid Email Address: spree@example.com")
  end

  it '#error_notification returns correct hash/structure' do
    subject.error_notification.should have_key(:notifications)
    subject.error_notification[:notifications].first[:level].should eq("error")
    subject.error_notification[:notifications].first[:subject].should eq("MailChimp Error Code: #{subject.code}")
    subject.error_notification[:notifications].first[:description].should eq(subject.msg)
  end
end
