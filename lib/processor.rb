class Processor

  def self.subscribe_to_list api_key, list_id, email, merge_vars={}
    mailchimp_list = MailChimpList.new(api_key)
    result = mailchimp_list.subscribe(list_id, email, merge_vars)

    if result == true
      self.info_notification( success_msg(email) )
    elsif (result.class == Hash) and (result["code"] == 214)
      self.info_notification( already_subscribed_msg(email) )
    else
      raise MailChimpError.new(result)
    end
  end

  private
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