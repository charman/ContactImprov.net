# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #  The object must belong to a class with the 'acts_as_versioned' property
  def attribute_changed_from_previous_version?(an_object, attribute_name)
    original_version = an_object.version

    if original_version <= 1
      return true
    end
    
    an_object.revert_to(original_version - 1)
    previous_value = an_object.send(attribute_name)
   
    an_object.revert_to(original_version)     #  Revert to original version before returning
    current_value = an_object.send(attribute_name)
    
    if current_value != previous_value
      return true
    else
      return false
    end
  end

  def is_users_model_current_model?(model_name)
    if @entry.send(model_name) && @entry.send(model_name).id == @user_person_entry.send(model_name).id
      true
    else
      false
    end
  end

	#  Converts a string written in CamelCase or mixed case to all lowercase
	#   with underscores in between the words, e.g.:
	#     Email           =>  email
	#     PhoneNumber     =>  phone_number
  #     United Kingdom  =>  united_kingdom
  def lower_under_ize(name)
  	name.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(' ', '_').gsub(',', '').downcase
  end

  def link_safe_name(name)
    name.gsub(' ', '_').gsub(/[\(\)\.',]/, "")
  end

  def obfuscate_email_with_javascript(e)
    return '' if e.blank?
    address, server = e.split('@')

    '<script language="javascript" type="text/javascript"><!--' + "\n" +
      '// email1 & email2 are the text on either side of your email address\'s @ sign.' + "\n" +
      "var email1 = \"#{address}\"\n" +
      "var email2 = \"#{server}\"\n" +
      'document.write("<a href=" + "mail" + "to:" + email1 + "@" + email2 + ">" + email1 + "@" + email2 + "</a>")' + "\n" +
      "// -->\n" + 
      "</script>"
  end

  #  The object must belong to a class with the 'acts_as_versioned' property
  def wrap_in_span_if_attribute_changed(an_object, attribute_name, span_options = 'style="font-weight: bold;"')
    if attribute_changed_from_previous_version?(an_object, attribute_name)
      "<span #{span_options}>#{an_object.send(attribute_name)}</span>"
    else
      an_object.send(attribute_name)
    end
  end
  
end
