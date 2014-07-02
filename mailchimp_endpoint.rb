Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  configure :development do
    enable :logging, :dump_errors, :raise_errors
    log = File.new("tmp/sinatra.log", "a")
    STDOUT.reopen(log)
    STDERR.reopen(log)
  end

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/add_to_list' do
    mailchimp = Mailchimp::API.new(api_key)

    begin
      if list_id.is_a?(Array)
        list_id.each do |list|
          mailchimp.lists.subscribe(list, { email: email }, merge_vars, 'html', false, true, false, false)
        end
      else
        mailchimp.lists.subscribe(list_id, { email: email }, merge_vars, 'html', false, true, false, false)
      end
    rescue => ex
      result 500, ex.message and return
    end

    result 200, "Successfully subscribed #{email} to the MailChimp list(s)"
  end

  private

  def email
    @payload['member']['email']
  end

  def list_id
    @payload['list_id']
  end

  def api_key
    @config['mailchimp_api_key']
  end

  def merge_vars
    {
      fname: @payload['member']['first_name'],
      lname: @payload['member']['last_name']
    }.merge(@payload['member'].except(*["email", "first_name", "last_name"]))
  end

  def message_id
    @message[:message_id]
  end
end
