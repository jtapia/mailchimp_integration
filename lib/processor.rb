class Processor

  def self.subscribe_to_list api_key, list_id, email, merge_vars={}
    mailchimp_list = MailChimpList.new(api_key)
    result = mailchimp_list.subscribe(list_id, email, merge_vars)

    if result == true
      self.info_notification( success_msg(email) )
    elsif (result.class == Hash) && (result["code"] == 214)
      self.info_notification( already_subscribed_msg(email) )
    elsif (result.class == Hash) && (result["code"] == 220)
      self.banned_notification result
    else
      raise MailChimpError.new(result)
    end
  end

  private
  def self.banned_notification(result)
    { notifications:
      [
        {
          level: "error",
          subject: "MailChimp Error Code: #{result["code"]}",
          description: result["error"]
        }
      ]
    }
  end

  def self.info_notification msg
    { notifications:
      [
        {
          level: "info"
        }.merge(msg)
      ]
    }
  end

  def self.success_msg email
    {
      subject: "Successfully subscribed #{email} to the MailChimp list",
      description: "Successfully subscribed #{email} to the MailChimp list"
    }
  end

  def self.already_subscribed_msg email
    {
      subject: "#{email} is already subscribed to the MailChimp list",
      description: "#{email} is already subscribed to the MailChimp list"
    }
  end
end
