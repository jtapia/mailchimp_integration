Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/add_to_list' do
    begin
      code = 200
      result = subscribe(api_key, list_id, email, merge_vars)
      if result == true
        set_summary "Successfully subscribed #{email} to the MailChimp list"
      elsif (result.class == Hash) && (result["code"] == 214)
        set_summary "#{email} is already subscribed to the MailChimp list"
      elsif (result.class == Hash) && (result["code"] == 220)
        set_summary "Mailchimp Error Code: #{result["code"]} - #{result["error"]}"
      else
        set_summary "Mailchimp Error Code: #{result.inspect}"
      end

    rescue => e
      code = 500
      set_summary "#{e.inspect} - #{e.backtrace}"
    end
    process_result code
  end

  private

  def subscribe api_key, list_id, email, merge_vars={}
    mailchimp = Mailchimp::API.new(api_key, :timeout => 60)

    mailchimp.list_subscribe(
      :id => list_id,
      :email_address => email,
      :merge_vars => merge_vars,
      :send_welcome => false,
      :double_optin => false
    )
  end

  def email
    @payload['member']['email']
  end

  def list_id
    @payload['list_id']
  end

  def api_key
    @config['mailchimp.api_key']
  end

  def merge_vars
      @payload['member'].except!("email")
  end

  def message_id
    @message[:message_id]
  end
end