class UserMailer < ActionMailer::Base
  
  def account_request(user_account_request)
    setup_admin_email()
    first_name = user_account_request.person.first_name
    last_name  = user_account_request.person.last_name
    email      = user_account_request.email.address
    @subject          += "Account request for #{first_name} #{last_name} (#{email})"
    @body[:first_name] = 
    @body[:last_name]  = last_name
    @body[:email]      = email
    @body[:something_about_contact_improv] = user_account_request.something_about_contact_improv
  end

  def activation(user)
    setup_user_email(user)
    @subject    = 'Your ContactImprov.net account has been activated'
    @body[:password] = user.password
    @body[:url] = "#{@base_url}"
  end

  def passive_user_login_attempt(email)
    setup_admin_email()
    @subject += "Login attempt from #{email} whose account needs to be configured"
  end

  def password_reset(user)
    setup_user_email(user)
    @subject    = 'Instructions for resetting your ContactImprov.net account password'
    @body[:url] = "#{@base_url}reset_password/#{user.password_reset_code}"
  end

  def password_reset_by_admin(user, new_password)
    setup_user_email(user)
    @subject = 'New password for your ContactImprov.net account'
    @body[:new_password] = new_password
  end
  
  def signup_notification(user)
    setup_user_email(user)
    @subject     = 'We have created a ContactImprov.net account for you'
    @body[:url]  = "#{@base_url}activate/#{user.activation_code}"
    if user && user.person
      @body[:name_of_user] = "#{user.person.first_name} #{user.person.last_name} -\n"
    else
      @body[:name_of_user] = ''
    end
  end

  def user_changed_email(old_email, new_email, user)
    setup_admin_email()

    if user
      @subject += "User '#{user.person.first_name} #{user.person.last_name}' changed their contact information"
    else
      @subject += "User '#{old_email}' changed their email address"
    end

    @body[:old_email] = old_email
    @body[:new_email] = new_email
  end


protected

  def filter_recipients(emails)
    #  Only deliver email on the production server
    if File.file? "config/deliver_email"
      @recipients = emails
      @bcc        = "ci@craigharman.net"
    else
      @recipients = "charman"
    end
  end

  def setup_admin_email()
    setup_email("ci@craigharman.net")
    @subject     = "[CQadmin]  "
  end

  def setup_email(email_addresses)
    filter_recipients(email_addresses)
    @from        = "ContactImprov.net <listings@contactimprov.net>"
    @sent_on     = Time.now
  end

  def setup_user_email(user)
    setup_email("#{user.email}")
    @base_url    = "http://www.contactimprov.net/"
    @body[:user] = user
  end

end
