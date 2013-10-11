class AuthorizationError < StandardError
end

class MailChimpError < StandardError
  attr_accessor :code, :msg
  
  def initialize error_hash={}
    @code = error_hash["code"]
    @msg  = error_hash["error"]
  end

  def error_notification
    { notifications:
      [
        {
          level: "error",
          subject: "MailChimp Error Code #{@code}",
          description: @msg
        }
      ]
    }
  end
end