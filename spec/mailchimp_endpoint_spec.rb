require 'spec_helper'

describe MailChimpEndpoint do

  let(:payload) {
    '{"request_id": "12e12341523e449c3000001",
      "parameters": {
        "mailchimp.api_key":"abc123-us5"
      },
      "list_id":"abc123",
      "member": {
        "email": "support@spreecommerce.com",
        "first_name": "Spree",
        "last_name": "Commerce"
      }
    }'
 }

  it "should respond to POST add_to_list" do
    VCR.use_cassette('mailchimp_add') do
      post '/add_to_list', payload, auth
      expect(last_response.status).to eql 200
      expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
      expect(json_response["summary"]).to match /Successfully subscribed/
    end
  end

end
