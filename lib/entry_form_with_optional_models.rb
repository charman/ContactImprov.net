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
      render :action => 'new'
    end
  end

  def delete
    return if !valid_id_and_permissions?(params[:id])

    @entry.destroy
  end

  def edit
    if params[:commit] == 'Delete'
      redirect_to :action => 'delete', :id => params[:id] 
      return
    end
    
    return if !valid_id_and_permissions?(params[:id])

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
      end
    end
  end

  def list
    @entries = entry_class.find(:all)
  end

  def new
    create_entry_and_linked_models
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
    mandatory_models_valid = mandatory_models.reject { |model_name| @entry.send(model_name).valid? }
    optional_models_valid = optional_models.reject { |model_name|
      model = @entry.send(model_name)
      model.completely_blank? or model.valid?
    }
 
    @error_messages = all_models.collect { |model_name| @entry.send(model_name).errors.full_messages }.flatten
    @error_messages += @entry.errors.full_messages
    
    entry_valid && mandatory_models_valid && optional_models_valid
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
