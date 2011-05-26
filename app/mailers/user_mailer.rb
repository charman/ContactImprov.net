class UserMailer < ActionMailer::Base
  
  def account_request(user_account_request)
    setup_admin_email()
    @first_name = user_account_request.person.first_name
    @last_name  = user_account_request.person.last_name
    @email      = user_account_request.email.address
    @something_about_contact_improv = user_account_request.something_about_contact_improv
    @subject          += "Account request for #{first_name} #{last_name} (#{email})"
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def activation(user)
    setup_user_email(user)
    @password = user.password
    @url = @base_url
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def entry_modified(entry, entry_type)
    setup_admin_email()
    @subject   += "Modified #{entry_type}: #{entry.title}"
    @entry      = entry
    @entry_type = entry_type
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def new_entry_created(entry, entry_type)
    setup_admin_email()
    @subject   += "New #{entry_type}: #{entry.title}"
    @entry      = entry
    @entry_type = entry_type
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def passive_user_login_attempt(email)
    setup_admin_email()
    @subject += "Login attempt from #{email} whose account needs to be configured"
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def password_reset(user)
    setup_user_email(user)
    @subject    = 'Instructions for resetting your ContactImprov.net account password'
    @url = "#{@base_url}reset_password/#{user.password_reset_code}"
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def password_reset_by_admin(user, new_password)
    setup_user_email(user)
    @subject = 'New password for your ContactImprov.net account'
    @new_password = new_password
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end
  
  def please_update_your_legacy_listing(email)
    setup_email(email)
    @subject = "How to update your listing on ContactImprov.net"
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def signup_notification(user)
    setup_user_email(user)
    @subject = 'We have created a ContactImprov.net account for you'
    @url     = "#{@base_url}activate/#{user.activation_code}"
    @user    = user
    if user && user.person
      @name_of_user = "#{user.person.first_name} #{user.person.last_name} -\n"
    else
      @name_of_user = ''
    end
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
  end

  def user_changed_email(old_email, new_email, user)
    setup_admin_email()

    if user
      @subject += "User '#{user.person.first_name} #{user.person.last_name}' changed their contact information"
    else
      @subject += "User '#{old_email}' changed their email address"
    end

    @old_email = old_email
    @new_email = new_email
    mail(:to => @recipients, :subject => @subject, :bcc => @bcc)
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
    @subject     = "[CI.net]  "
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
