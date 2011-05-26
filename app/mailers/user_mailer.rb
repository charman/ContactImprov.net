class UserMailer < ActionMailer::Base

  default :from => "ContactImprov.net <listings@contactimprov.net>"

  
  def activation(user)
    setup_user_email(user)
    @password = user.password
    @url = @base_url
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

  def setup_user_email(user)
    filter_recipients(user.email)
    @sent_on     = Time.now
    @base_url    = "http://www.contactimprov.net/"
    @body[:user] = user
  end

end
