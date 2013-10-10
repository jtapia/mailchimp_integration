class MailChimpList < MailChimpConfig
  
  def subscribe list_id, email, merge_vars={}
    mailchimp.list_subscribe(
      :id => list_id,
      :email_address => email,
      :merge_vars => merge_vars,
      :send_welcome => false,
      :double_optin => false
    )
  end
end
