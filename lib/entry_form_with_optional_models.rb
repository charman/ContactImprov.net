module EntryFormWithOptionalModels

  def create
    create_entry_and_linked_models
    
    initialize_entry_and_linked_models_from_params(params)
    
    if entry_and_linked_models_valid?
      delete_completely_blank_models
      @entry.owner_user = current_user
      @entry.save!
      redirect_to :controller => 'user', :action => 'index'
    else
      render :partial => "shared/entries/new", :locals => { :entry_display_name => entry_display_name }
    end
  end

  def delete
    @entry.destroy if valid_id_and_permissions?(params[:id])

    render :partial => "shared/entries/delete", :locals => { :entry_display_name => entry_display_name }
  end

  def edit
    if params[:commit] =~ /Delete/
      redirect_to :action => 'delete', :id => params[:id] 
      return
    end

    if valid_id_and_permissions?(params[:id])
      optional_models.each { |model_name| eval("@entry.#{model_name} ||= #{model_name.camelize}.new") }

      if request.put?
        initialize_entry_and_linked_models_from_params(params)

        if entry_and_linked_models_valid?
          delete_completely_blank_models
          mandatory_models.each { |model_name| @entry.send(model_name).save! }
          optional_models.each do |model_name| 
            model = @entry.send(model_name)
            model.save! if not model.completely_blank?
          end
          @entry.save!
          redirect_to :controller => 'user', :action => 'index'
          return  #  We need to return here so that redirect_to and render aren't both called
        end
      end
    end

    #  render needs to be called *after* @entry is initialized (or not) in valid_id_and_permissions?
    render :partial => "shared/entries/edit", :locals => { :entry_display_name => entry_display_name }
  end

  def list
    @entries = entry_class.find(:all)
  end

  def new
    create_entry_and_linked_models

    render :partial => "shared/entries/new", :locals => { :entry_display_name => entry_display_name }
  end


protected

  def all_models
    mandatory_models + optional_models
  end

  def create_entry_and_linked_models
    @entry = entry_class.new
    all_models.each { |model_name| eval("@entry.#{model_name} = #{model_name.camelize}.new") }
  end

  #  TODO: Do we *really* want to delete the linked models?  Would we ever link to
  #         the same Email/Location from multiple models?
  def delete_completely_blank_models
    optional_models.each do |model_name|
      model = @entry.send(model_name)
      if model.completely_blank?
        model.destroy
        model = nil
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
      if model_name == 'url'
        #  We can't use 'url' as a parameter name because of a namespace conflict with a Rails variable
        #  TODO: Check if this has really been fixed in Rails 2.3/3.0, per deprecation warning.
        @entry.send(model_name).attributes = p[:entry][:ci_url]
      else
        @entry.send(model_name).attributes = p[:entry][model_name]
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
    if !@current_user.admin? && (@current_user != @entry.owner_user || @entry.owner_user == nil)
      flash[:notice] = "<h2>Access Denied</h2><p>You do not have permission to edit this #{entry_display_name}.</p>"
      return false
    end

    true
  end

end
