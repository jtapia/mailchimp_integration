require 'spec_helper'

describe MailChimpEndpoint do

  let(:message) {
    {
      'store_id' => '123229227575e4645c000001',
      'message_id' => 'abc',
      'payload' => Factories.payload( {:parameters => Factories.config} )
    }
  }

  def app
    MailChimpEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end

  it 'subscribes new email to a MailChimp list' do
    VCR.use_cassette('processor_subscribe_success') do
      Processor.should_receive(:subscribe_to_list)
        .with( Factories.api_key, Factories.list_id, Factories.order['email'], anything )
        .and_return( Processor.info_notification(Processor.success_msg(Factories.order['email'])) )

      post '/subscribe', message.to_json, auth

      last_response.status.should eq(200)

      last_response.body.should match("message_id")
      last_response.body.should match("email")
      last_response.body.should match("list_id")
      last_response.body.should match("notifications")
      last_response.body.should match("Successfully subscribed")
    end
  end

  it 'succeeds if email is already subscribed' do
    VCR.use_cassette('processor_subscribe_invalid_already_subscribed') do
      Processor.should_receive(:subscribe_to_list)
        .with( Factories.api_key, Factories.list_id, Factories.order['email'], anything )
        .and_return( Processor.info_notification(Processor.already_subscribed_msg(Factories.order['email'])) )

      post '/subscribe', message.to_json, auth

      last_response.status.should eq(200)

      last_response.body.should match("message_id")
      last_response.body.should match("email")
      last_response.body.should match("list_id")
      last_response.body.should match("notifications")
      last_response.body.should match("is already subscribed")
    end
  end

  it 'fails if MailChimp returns an error' do
    VCR.use_cassette('processor_subscribe_invalid_email') do
      post '/subscribe', message.to_json, auth

      last_response.status.should eq(500)

      last_response.body.should match("message_id")
      last_response.body.should match("email")
      last_response.body.should match("list_id")
      last_response.body.should match("notifications")
      last_response.body.should match("Invalid Email Address")
    end
  end

  context "banned email" do
    let(:email) { "etwaun@yahoo.coom" }

    it "returns 200 with notification error message" do
      message['payload']['order']['email'] = "etwaun@yahoo.coom"

      VCR.use_cassette('processor_subscribe_banned_email') do
        post '/subscribe', message.to_json, auth

        expect(last_response.status).to eq 200
        expect(last_response.body).to match "notifications"
        expect(last_response.body).to match "error"
      end
    end
  end
end
