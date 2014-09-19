require 'spec_helper'

describe MailChimpEndpoint do
  context 'list_id is in root' do
    let(:payload) {
      '{"request_id": "12e12341523e449c3000001",
        "parameters": {
          "mailchimp_api_key":"apikey"
        },
        "list_id":"a5b08674ef",
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

  context 'multiple list_id inside member body' do
    let(:payload) {
      '{"request_id": "12e12341523e449c3000001",
        "parameters": {
          "mailchimp_api_key":"apikey"
        },
        "member": {
          "email": "bruno+mailchampion@spreecommerce.com",
          "first_name": "Bruno",
          "last_name": "Buccolo",
          "list_id":["a5b08674ef","fa2c2d7aed"]
        }
      }'
    }

    it "should respond to POST add_to_list" do
      VCR.use_cassette('mailchimp_multiple_add') do
        post '/add_to_list', payload, auth

        expect(last_response.status).to eql 200
        expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
        expect(json_response["summary"]).to match /Successfully subscribed/
      end
    end
  end

  context 'update_member in a list_id is in root' do
    let(:payload) {
      '{"request_id": "12e12341523e449c3000001",
        "parameters": {
          "mailchimp_api_key":"apikey"
        },
        "list_id":"a5b08674ef",
        "member": {
          "email": "support@spreecommerce.com",
          "first_name": "Spree",
          "last_name": "Commerce"
        }
      }'
    }

    it "should respond to POST update_member" do
      VCR.use_cassette('mailchimp_update') do
        post '/update_member', payload, auth

        expect(last_response.status).to eql 200
        expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
        expect(json_response["summary"]).to match /Successfully updated/
      end
    end
  end
end
