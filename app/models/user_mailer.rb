class UserMailer < ActionMailer::Base
  
  def account_request(first_name, last_name, email)
    setup_admin_email()
    @subject          += "Account request for #{first_name} #{last_name} (#{email})"
    @body[:first_name] = first_name
    @body[:last_name]  = last_name
    @body[:email]      = email
  end

  def activation(user)
    setup_user_email(user)
    @subject    = 'Your ContactImprov.net account has been activated'
    @body[:password] = user.password
    @body[:url] = "#{@base_url}"
  end

  def contacts_application_accepted(application)
    setup_email(application.email.address)
    @subject    = "ContactImprov.net's Contacts List"
    @body[:user_name] = "#{application.person.first_name} #{application.person.last_name}"
  end

  def contacts_application_received(application)
    setup_cq_staff_email()
    @subject = "Contacts List Application received"
    body[:applicant_name] = "#{application.person.first_name} #{application.person.last_name}"
    if application.owner_user_id
      user = User.find(application.owner_user_id)
      @body[:user_name] = "#{user.person.first_name} #{user.person.last_name}"
    else
      @body[:user_name] = nil
    end
  end

  def contacts_application_rejected(application)
    setup_email(application.email.address)
    @subject    = "ContactImprov.net's Contacts List"
    @body[:user_name] = "#{application.person.first_name} #{application.person.last_name}"
  end

  def contacts_notification_for_active_account(entry)
    email = entry.resources_of_type('Email')[0].address
    setup_email(email)
    @body[:entry_id] = entry.id
    @body[:is_not_a_subscriber] = !entry.owner_user.is_current_subscriber?
    @subject = "CQ Contacts: Please Update your Listing Online!"
  end

  def contacts_notification_for_pending_account(entry)
    email = entry.resources_of_type('Email')[0].address
    setup_email(email)
    @body[:activation_code] = entry.owner_user.activation_code
    @body[:entry_id] = entry.id
    @body[:is_not_a_subscriber] = !entry.owner_user.is_current_subscriber?
    @subject = "CQ Contacts: Please Update your Listing Online!"
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
  
  #  TODO: Should we deliver different messages to new subscribers vs. contacts vs. other
  #         classes of users?
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

  def subscriber_notification(user)
    setup_user_email(user)
    @subject     = 'New online subscriber-only features on ContactImprov.net website!'
    @body[:url]  = "#{@base_url}activate/#{user.activation_code}"
    if user && user.person
      @body[:user_greeting] = "Dear #{user.person.first_name} #{user.person.last_name},"
    else
      @body[:user_greeting] = ''
    end
  end

  def user_changed_contact_info(user)
    setup_admin_email()

    if user && user.person && user.person.versions && user.person.versions.latest && user.person.versions.latest.previous
      @subject += "User '#{user.person.first_name} #{user.person.last_name}' (#{user.email}) changed their contact information"

      new_person = user.person
      old_person = user.person.versions.latest.previous
      if new_person.first_name != old_person.first_name || new_person.last_name != old_person.last_name
        @body[:name_changed] = true
        @body[:new_person]   = new_person
        @body[:old_person]   = old_person
      else
        @body[:name_changed] = false
      end
    elsif user && user.person
      @subject += "User '#{user.person.first_name} #{user.person.last_name}' (#{user.email}) changed their contact information"
      @body[:name_changed] = false
    else
      @subject += "User '#{user.email}' changed their contact information"
      @body[:name_changed] = false
    end

    if user && 
       user.subscriber_address && 
       user.subscriber_address.versions &&
       user.subscriber_address.versions.latest &&
       user.subscriber_address.versions.latest.previous
      # Make a copy of the original object so that new_object and old_object are not the same object
      new_location = user.subscriber_address.clone
      old_location = user.subscriber_address
      old_location.revert_to(old_location.versions.latest.previous)
      changed_attributes = new_location.attributes_that_differ_from(old_location)
      if !changed_attributes.empty?
        @body[:address_changed] = true
        @body[:new_address] = Location.column_names.inject(String.new) { |s, attribute_name| 
          s += sprintf("  %-23s-   %s\n", Location.human_attribute_name(attribute_name).titlecase, new_location.human_readable_attribute(attribute_name))
        }
        @body[:changed_address_fields] = new_location.attributes_that_differ_from(old_location).inject(String.new) { |s, attribute_name| 
          s += sprintf("  %-23s-   %s\n", Location.human_attribute_name(attribute_name).titlecase, old_location.human_readable_attribute(attribute_name))
        }
      else
        @body[:address_changed] = false
      end
    else
      @body[:address_changed] = false
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
        @bcc        = "cq@craigharman.net"
      else
        @recipients = "charman"
      end
    end
  
    def setup_admin_email()
      setup_email("cq@craigharman.net")
      @subject     = "[CQadmin]  "
    end

    def setup_cq_staff_email()
      setup_email(["editor@contactquarterly.com", 
                   "info@contactquarterly.com", 
                   "submissions@contactquarterly.com"])
    end

    def setup_email(email_addresses)
      filter_recipients(email_addresses)
      @from        = "ContactImprov.net <web@contactquarterly.com>"
      @sent_on     = Time.now
    end
  
    def setup_user_email(user)
      setup_email("#{user.email}")
      @base_url    = "https://community.contactquarterly.com/"
      @body[:user] = user
    end
end
