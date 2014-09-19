Dir['./lib/**/*.rb'].each(&method(:require))

class MailChimpEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  configure :development do
    enable :logging, :dump_errors, :raise_errors
  end

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/add_to_list' do
    begin
      mailchimp = Mailchimp::API.new(api_key)

      list_ids.each {|list_id| subscribe(mailchimp, list_id)}
    rescue => ex
      result 500, ex.message and return
    end

    result 200, "Successfully subscribed #{email} to the MailChimp list(s)"
  end

  post '/update_member' do
    begin
      mailchimp = Mailchimp::API.new(api_key)

      list_ids.each {|list_id| update_member(mailchimp, list_id)}
    rescue => ex
      result 500, ex.message and return
    end

    result 200, "Successfully updated #{email} to the MailChimp list(s)"
  end

  private

  def email
    @payload['member']['email']
  end

  def list_ids
    Array(@payload['list_id'] || @payload['member']['list_id'])
  end

  def api_key
    @config['mailchimp_api_key']
  end

  def merge_vars type
    case type
      when 'add'
        {
          fname: @payload['member']['first_name'],
          lname: @payload['member']['last_name']
        }.merge(@payload['member'].except(*["email", "first_name", "last_name"]))
      when 'update'
        {
          'new-email' => @payload['member']['new_email']
        }.merge(@payload['member'].except(*["email", "new_email"]))
    end
  end

  def message_id
    @message[:message_id]
  end

  def subscribe(mailchimp, list_id)
    mailchimp.lists.subscribe(list_id, { email: email }, merge_vars('add'), 'html', false, true, false, false)
  end

  def update_member(mailchimp, list_id)
    mailchimp.lists.update_member(list_id, { email: email }, merge_vars('update'), 'html', true)
  end
end
