class Processor

  def self.subscribe_to_list api_key, list_id, email, merge_vars={}
    mailchimp_list = MailChimpList.new(api_key)
    result = mailchimp_list.subscribe(list_id, email, merge_vars)

    if result == true
      self.success_notification(email)
    elsif (result.class == Hash) and (result["code"] == 214)
      self.success_notification(email)
    else 
      self.process_error result
    end
  end

  private
  def self.success_notification email
    { notifications:
      [
        {
          level: "info",
          subject: "Successfully Subscribed #{email} To The MailChimp List",
          description: "Successfully Subscribed #{email} To The MailChimp List"
        }
      ]
    }
  end

  def self.process_error error_hash
    { notifications:
      [
        {
          level: "error",
          subject: "MailChimp Error Code #{error_hash['code']}",
          description: error_hash["error"]
        }
      ]
    }
  end
end 