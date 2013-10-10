Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase
  set :logging, true

  post '/subscribe' do
    begin
      code = 200
      response = Processor.subscribe_to_list(api_key, list_id, email, merge_vars)
    rescue => e
      code = 500
      response = error_notification(e)
    end
    process_result code, base_msg.merge(response)
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

  def error_notification(e)
    { notifications:
      [
        {
          level: "error",
          subject: e.message,
          description: e.backtrace.to_a.join('\n\t')
        }
      ]
    }
  end
end