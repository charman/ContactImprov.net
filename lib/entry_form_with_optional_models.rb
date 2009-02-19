module EntryFormWithOptionalModels

  def create
    create_entry_and_linked_models
    set_has_person_entry_variables
    initialize_entry_and_linked_models_from_params(params)
    
    @entry.owner_user = current_user

    if entry_and_linked_models_valid?
      disconnect_completely_blank_models
      @entry.save!
      flush_location_cache(entry_display_name, @entry.location)
      UserMailer.deliver_new_entry_created(@entry, entry_display_name)
      redirect_to :action => 'show', :id => @entry.id
    else
      render :partial => "shared/entries/new", :locals => { 
        :category_name_singular => category_name_singular,
        :entry_display_name     => entry_display_name
      }
    end
  end

  def delete
    if valid_id_and_permissions?(params[:id])
      flush_location_cache(entry_display_name, @entry.location)
      @entry.destroy 
    end

    render :partial => "shared/entries/delete", :locals => { 
      :category_name_singular => category_name_singular,
      :entry_display_name     => entry_display_name
    }
  end

  def edit
    if params[:commit] =~ /Delete/
      redirect_to :action => 'delete', :id => params[:id] 
      return
    end

    @entry_type = entry_display_name.downcase

    if valid_id_and_permissions?(params[:id])
      optional_models.each { |model_name| eval("@entry.#{model_name} ||= #{model_name.camelize}.new") }

      set_has_person_entry_variables

      if request.put?
        initialize_entry_and_linked_models_from_params(params)

        if entry_and_linked_models_valid?
          disconnect_completely_blank_models

          mandatory_models.each { |model_name| @entry.send(model_name).save! }
          optional_models.each do |model_name| 
            model = @entry.send(model_name)
            model.save! if (model && !model.completely_blank?)
          end

          @entry.save!
          flush_location_cache(entry_display_name, @entry.location)
          UserMailer.deliver_entry_modified(@entry, entry_display_name)
          redirect_to :action => 'show', :id => @entry.id
          return  #  We need to return here so that redirect_to and render aren't both called
        end
      end
    end

    #  render needs to be called *after* @entry is initialized (or not) in valid_id_and_permissions?
    render :partial => "shared/entries/edit", :locals => { 
      :category_name_singular => category_name_singular,
      :entry_display_name     => entry_display_name
    }
  end

  def new
    create_entry_and_linked_models
    set_has_person_entry_variables

    render :partial => "shared/entries/new", :locals => { :category_name_singular => category_name_singular }
  end

  def show
    @entry = entry_class.find(params[:id]) if entry_class.exists?(params[:id])
    @entry_type = entry_display_name.downcase
    @entry_editable_by_user = current_user_can_modify_entry?(@entry)

    render :partial => "shared/entries/show", :locals => { :category_name_singular => category_name_singular }
  end


protected

  def all_models
    mandatory_models + optional_models
  end

  def create_entry_and_linked_models
    @entry = entry_class.new
    all_models.each { |model_name| eval("@entry.#{model_name} = #{model_name.camelize}.new") }
  end

  #  TODO: We are currently disconnecting the completely blank linked models instead of
  #         destroying them.  We should destroy the linked models iff they are not linked
  #         to any other models.  As is, we're creating orphaned database records.
  def disconnect_completely_blank_models
    optional_models.each do |model_name|
      if @entry.respond_to?(model_name) && @entry.send(model_name) && @entry.send(model_name).completely_blank?
        eval("@entry.#{model_name} = nil")
#        model = @entry.send(model_name)
#        model.destroy
#        model = nil
      end
    end
  end

  def entry_and_linked_models_valid?
    entry_valid = @entry.valid?
    mandatory_models_valid = mandatory_models.reject { |model_name| @entry.send(model_name).valid? }.empty?
    optional_models_valid = optional_models.reject { |model_name|
      model = @entry.send(model_name)
      model.completely_blank? or model.valid?
    }.empty?
 
    @error_messages = all_models.collect { |model_name| @entry.send(model_name).errors.full_messages }.flatten
    @error_messages += @entry.errors.full_messages
    
    entry_valid && mandatory_models_valid && optional_models_valid
  end

  def initialize_entry_and_linked_models_from_params(p)
    @entry.attributes = p[entry_class.to_s.tableize.singularize]
    all_models.each do |model_name| 
      #  Check if the checkbox for "Use my [model_name] ([model values])" is checked
      if p.has_key?('use_user_person_entry_for') && p[:use_user_person_entry_for].has_key?(model_name)
        #  TODO: If the user had created a separate model and then specifies that they want to
        #         use the model associated with their PersonEntry, we need to clean up the original
        #         model.  As is, we're currently orphaning database records.
        eval("@entry.#{model_name} = @user_person_entry.#{model_name}")
      else
        #  lemma: The checkbox for "Use my [model_name] ([model values])" is unchecked, per the if clause above
        #  If the checkbox is unchecked and this @entry's model_name is the same instance as the model
        #   associated with the user's PersonEntry, then we need to create a new model for @entry so that
        #   changes to @entry's model don't modify the original model associated with the user's PersonEntry.
        if @entry.send(model_name) && @user_has_person_entry && @user_person_entry.send(model_name) && (@entry.send(model_name).id == @user_person_entry.send(model_name).id)
          eval("@entry.#{model_name} = #{model_name.camelize}.new")
        end

        if model_name == 'url'
          #  We can't use 'url' as a parameter name because of a namespace conflict with a Rails variable
          #  TODO: Check if this has really been fixed in Rails 2.3/3.0, per deprecation warning.
          @entry.send(model_name).attributes = p[:entry][:ci_url]
        else
          @entry.send(model_name).attributes = p[:entry][model_name]
        end
      end
    end
    if defined?(@entry.boolean_flag_names) && !@entry.boolean_flag_names.empty?
      @entry.boolean_flag_names.each { |flag_name| set_boolean_flag(flag_name, p[flag_name]) }
    end
  end

  def set_boolean_flag(flag_name, flag)
    if flag == false || flag == :false || flag == 'false' || flag.blank?
      eval("@entry.#{flag_name} = false")
    else  #  status is true
      eval("@entry.#{flag_name} = true")
    end
  end

  #  TODO: We're modifying global variables in this and other protected functions.  Isn't there a better way?
  def set_has_person_entry_variables
    if entry_display_name == 'Event' && @current_user.own_person_entry_id
      @user_has_person_entry = true
      @user_person_entry = @current_user.own_person_entry
    else
      @user_has_person_entry = false
    end
  end

  #  This function assumes that the @current_user variable points to a valid instance 
  #   of User. This can be enforced by using:
  #     before_filter :login_required
  #   for all actions that call this function.
  def valid_id_and_permissions?(id)
    if not params.has_key?(:id)
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>#{entry_display_name} not Found</h2><p>No #{entry_display_name} ID was provided</p>"
      return false
    end

    begin
      @entry = entry_class.find(id)
    rescue ActiveRecord::RecordNotFound
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>#{entry_display_name} not Found</h2><p>Unable to find the #{entry_display_name} you are searching for.</p>"
      return false
    end

    #  Restrict access to admins or the user who owns the current contact entry
    if !current_user_can_modify_entry?(@entry)
      flash[:notice] = "<h2>Access Denied</h2><p>You do not have permission to edit this #{entry_display_name}.</p>"
      return false
    end

    true
  end

end
