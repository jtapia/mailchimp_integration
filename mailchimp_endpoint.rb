Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/add_to_list' do
    begin
      code = 200
      mailchimp_list = MailChimpList.new(api_key)
      result = mailchimp_list.subscribe(list_id, email, merge_vars)
      if result == true
        set_summary "Successfully subscribed #{email} to the MailChimp list"
      elsif (result.class == Hash) && (result["code"] == 214)
        set_summary "#{email} is already subscribed to the MailChimp list"
      elsif (result.class == Hash) && (result["code"] == 220)
        set_summary "Mailchimp Error Code: #{result["code"]} - #{result["error"]}"
      else
        raise MailChimpError.new(result)
      end

    rescue => e
      code = 500
      set_summary e.error_notification
    end
    process_result code
  end

  private

  def order
    @message[:payload]['order']
  end

  def email
    order['email']
  end

  def list_id
    @config['mailchimp.list_id']
  end

  def api_key
    @config['mailchimp.api_key']
  end

  def merge_vars
    {
      'FNAME' => order['billing_address']['firstname'],
      'LNAME' => order['billing_address']['lastname']
    }
  end

  def message_id
    @message[:message_id]
  end

  def base_msg
    { 
      'message_id' => message_id,
      'email' => email,
      'list_id' => list_id
    }
  end
end