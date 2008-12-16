module AutoCompleteWithParamsPrefix      
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  # 
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion, 
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more examples, see script.aculo.us:
  # * http://script.aculo.us/demos/ajax/autocompleter
  # * http://script.aculo.us/demos/ajax/autocompleter_customized
  
  
  #  [CTH, 26 May 2008]
  #
  #  This is a modified version of the auto_complete plugin.
  #
  #  We want to be able to auto-complete country and US state information when editing a 
  #   Location.  Originally, the auto-complete form was created using this code in the view:
  #     <%= text_field_with_auto_complete :us_state, :name %>
  #   which would post the text to be auto-completed back to the auto_complete_us_state_name
  #   action that was created using this code in the controller:
  #     auto_complete_for :us_state, :name
  #
  #  Auto-completion broke after I refactored the location fields of the form into the
  #   shared/location partial template.  When the form is submitted, the country_name data is
  #   expected to be stored as params["#{prefix}"][:us_state][:name] for some sub-form prefix (e.g.
  #   params[:user][:subscriber_address][:us_state][:name]).  So we use this code in the view:
  #     <%= text_field_with_auto_complete :country_name, :english_name, {:name => "#{prefix}[country_name][english_name]"} %> 
  #   But the auto_complete_us_state action is expecting the country_name data to be stored 
  #   as params[:us_state][:name].  We want to have multiple Location objects on a single 
  #   form, so we need each Location object to have a unique prefix to use to store its
  #   information in params.  But we want to use the same auto_complete_us_state action for
  #   all of the Location objects on the form, so we want to ignore the prefix when auto-completing
  #   UsState (or CountryName) fields.
  #  
  #  This module solves the problem by having the auto_complete action get rid of the "prefix" portion
  #   of the params hash-of-hashes data structure.  The params data structure looks something like this:
  #     {:action => {...}, 
  #      :controller => {...},
  #      :user => {:subscriber_address => {:us_state => {:name => 'New York' }}}}
  #   so, in this example, we look for :us_state in the first level of the hash, and if it's not 
  #   there, we traverse the hash-of-hashes data structure (there are three keys at the top level,
  #   two of which we can discard, and only one key at each subsequent level) looking for the
  #   :us_state hash key.
  #
  #  In order to use multiple Location (or whatever) objects on a single form, each object needs
  #   a unique DOM ID.  The text_field_with_prefix_and_auto_complete helper function (my modified
  #   version of the text_field_with_auto_complete) can be used to create a unique DOM ID based
  #   on the same prefix that is used for the auto-complete fields.
  #
  #  TODO: We currently don't do any error checking when traversing the params data structure.
  module ClassMethods
    def auto_complete_with_params_prefix_for(object, method, options = {})
      define_method("auto_complete_for_#{object}_#{method}") do
        if !params.has_key?(object)
          keys = params.keys
          keys.delete("action")
          keys.delete("controller")
          new_params = params[keys[0]]
          # TODO: Implement an elegent recursive function here...
          return if new_params.blank? 
          if !new_params.has_key?(object)
            new_params = new_params[new_params.keys[0]]
            return if new_params.blank? 
            if !new_params.has_key?(object)
              new_params = new_params[new_params.keys[0]]
            end
          end
        else
          new_params = params
        end

        find_options = { 
          :conditions => [ "LOWER(#{method}) LIKE ?", '%' + new_params[object][method].downcase + '%' ], 
          :order => "#{method} ASC",
          :limit => 10 }.merge!(options)

        @items = object.to_s.camelize.constantize.find(:all, find_options)

        render :inline => "<%= auto_complete_result @items, '#{method}' %>"
      end
    end
  end
  
end
