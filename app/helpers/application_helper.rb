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

  def obfuscate_email_with_javascript(e)
    address, server = e.split('@')

    '<script language="javascript" type="text/javascript"><!--' + "\n" +
      '// email1 & email2 are the text on either side of your email address\'s @ sign.' + "\n" +
      "var email1 = \"#{address}\"\n" +
      "var email2 = \"#{server}\"\n" +
      'document.write("<a href=" + "mail" + "to:" + email1 + "@" + email2 + ">" + email1 + "@" + email2 + "</a>")' + "\n" +
      "// -->\n" + 
      "</script>"
  end

  #  This is a modified version of the text_field_with_auto_complete function from
  #   the auto_complete plugin.  This function also contains some (modified) code 
  #   from the auto_complete_field function from the auto_complete plugin.
  #  This modified version of text_field_with_auto_complete is designed to solve
  #   a problem that occurs when using  an auto-complete field multiple times
  #   in the same form - e.g., when modifying multiple Location objects on the same 
  #   form that each have auto-completing country_name and us_state fields.
  #
  #  A call to the standard text_field_with_auto_complete generates some HTML and (for
  #   parameters prefix='us_state' and object='name') the following JavaScript call:
  #
  #     var us_state_name_auto_completer =                                        #1 - JavaScript object
  #        new Ajax.Autocompleter('us_state_name',                                #2 -  id_of_text_field
  #                               'us_state_name_auto_complete',                  #3 -  id_of_div_to_populate
  #                               '/user/auto_complete_for_us_state_name', {})    #4 -  auto_complete_url
  #
  #  For a form with two instances of an auto-complete field, we want the name of the 
  #   JavaScript object and the ID's of the text field and div to be unique for each
  #   instance of the auto-complete field - i.e., we want to be able to tack on a prefix
  #   to #1, #2 and #3.  But we want to use the same auto-complete URL for all instances
  #   of the auto-complete field in the form - i.e., no prefix for #4.  This function
  #   generates the correct HTML for this case.
  #
  #  This function is related to the auto_complete plugin's auto_complete_for function,
  #   as well as my modified version of auto_complete_for named 
  #   auto_complete_with_params_prefix_for, which addresses *another* problem (this time
  #   with generating the auto-complete controller actions) that occurs when using multiple
  #   copies of an auto-complete field on a single form.
  #
  #  TODO: When I combined code from the text_field_with_auto_complete and auto_complete_for
  #         functions, I removed some functionality that may or may not come in handy some day.
  def text_field_with_prefix_and_auto_complete(prefix, object, method, tag_options = {})
    #  Convert brackets in the prefix string to underscores (e.g. 'user[person]' becomes 'user_person_')
    uprefix = prefix.gsub('[', '_').gsub(']', '_')

    tag_options = tag_options.merge(:id => "#{uprefix}#{object}_#{method}")

    field_id = "#{object}_#{method}"
    options  =  { :url => { :action => "auto_complete_for_#{object}_#{method}" } }

    function =  "var #{uprefix}#{field_id}_auto_completer = new Ajax.Autocompleter("
    function << "'#{uprefix}#{field_id}', "
    function << "'" + (options[:update] || "#{uprefix}#{field_id}_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"
    function << ', {})'

    auto_complete_stylesheet +
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{uprefix}#{object}_#{method}_auto_complete", :class => "auto_complete") +
    javascript_tag(function)
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
