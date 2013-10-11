require './lib/errors'

class MailChimpConfig
  attr_accessor :api_key, :mailchimp

  def initialize key
    @api_key = key
    validate!
    @mailchimp = Mailchimp::API.new(api_key, :timeout => 60)
  end

  private
  def validate!
    raise AuthorizationError, "API key must be provided" if (api_key.nil? or api_key.empty?)
  end
end
