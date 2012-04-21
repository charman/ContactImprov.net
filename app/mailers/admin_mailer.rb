class AdminMailer < ActionMailer::Base

  default :to => "ci@craigharman.net", :from => "ContactImprov.net <listings@contactimprov.net>"
  
  
  def account_request(user_account_request)
    @first_name = user_account_request.person.first_name
    @last_name  = user_account_request.person.last_name
    @email      = user_account_request.email.address
    @something_about_contact_improv = user_account_request.something_about_contact_improv

    mail :subject => subject_prefix + "Account request for #{@first_name} #{@last_name} (#{@email})",
      :content_type => "text/plain"
  end

  def entry_modified(entry, entry_type)
    @entry      = entry
    @entry_type = entry_type

    mail :subject => subject_prefix + "Modified #{entry_type}: #{entry.title}",
      :content_type => "text/plain"
  end

  def invalid_password_reset_code(reset_code)
    mail :subject => subject_prefix + "Invalid password reset code - #{reset_code}",
      :content_type => "text/plain"
  end

  def new_entry_created(entry, entry_type)
    @entry      = entry
    @entry_type = entry_type

    mail :subject => subject_prefix + "New #{entry_type}: #{entry.title}",
      :content_type => "text/plain"
  end

  def passive_user_login_attempt(email)
    mail :subject => subject_prefix + "Login attempt from #{email} whose account needs to be configured",
      :content_type => "text/plain"
  end

  def user_changed_email(old_email, new_email, user)
    if user
      subject = "User '#{user.person.first_name} #{user.person.last_name}' changed their contact information"
    else
      subject = "User '#{old_email}' changed their email address"
    end

    @old_email = old_email
    @new_email = new_email

    mail :subject => subject_prefix + subject,
      :content_type => "text/plain"
  end


protected

  def subject_prefix
    "[CI.net]  "
  end

end
