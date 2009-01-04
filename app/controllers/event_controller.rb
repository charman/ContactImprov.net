class EventController < ApplicationController

  auto_complete_with_params_prefix_for :country_name, :english_name
  auto_complete_with_params_prefix_for :us_state, :name

  before_filter :login_required, :only => [:create, :edit, :new]

  skip_before_filter :verify_authenticity_token, 
    :only => ['auto_complete_for_country_name_english_name', 'auto_complete_for_us_state_name']


  def create
    create_event_and_linked_models
    
    initialize_event_and_linked_models_from_params(params)
    
    if event_and_linked_models_valid?
      delete_completely_blank_models
      @event_entry.owner_user = current_user
      @event_entry.save!
      redirect_to :controller => 'user', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def delete
    return if !valid_id_and_permissions?

    @event_entry.destroy
  end

  def edit
    if params[:commit] == 'Delete'
      redirect_to :action => 'delete', :id => params[:id] 
      return
    end
    
    return if !valid_id_and_permissions?

    @event_entry.person       ||= Person.new
    @event_entry.email        ||= Email.new
    @event_entry.phone_number ||= PhoneNumber.new
    @event_entry.url          ||= Url.new

    if request.put?
      initialize_event_and_linked_models_from_params(params)

      if event_and_linked_models_valid?
        delete_completely_blank_models
        @models_that_can_be_completely_blank.each { |m| m.save! if not m.completely_blank? }
        @models_that_must_be_valid.each { |m| m.save! }
        # lemma: @event_entry is the last event to be saved
        redirect_to :controller => 'user', :action => 'index'
      end
    end
  end

  def list
    @events = EventEntry.find(:all)
  end

  def new
    create_event_and_linked_models
  end


protected

  def create_event_and_linked_models
    @event_entry = EventEntry.new
    @event_entry.person       = Person.new
    @event_entry.email        = Email.new
    @event_entry.location     = Location.new
    @event_entry.phone_number = PhoneNumber.new
    @event_entry.url          = Url.new
  end

  #  TODO: Do we *really* want to delete the linked models?  Would we ever link to
  #         the same Email/Location from multiple models?
  def delete_completely_blank_models
    @models_that_can_be_completely_blank.each do |model|
      if model.completely_blank?
        model.destroy
        model = nil
      end
    end
  end

  def event_and_linked_models_valid?
    models_are_completely_blank_or_valid = @models_that_can_be_completely_blank.reject { |model|
      model.completely_blank? or model.valid?
    }.empty?
    models_are_valid = @models_that_must_be_valid.reject { |model|
      model.valid?
    }.empty?
 
    @error_messages = @all_linked_models.collect { |m| m.errors.full_messages }.flatten
    
    models_are_valid && models_are_completely_blank_or_valid
  end
  
  def initialize_event_and_linked_models_from_params(p)
    @event_entry.attributes = p[:event_entry]
    @event_entry.person.attributes       = p[:event][:person]
    @event_entry.email.attributes        = p[:event][:email]
    @event_entry.location.attributes     = p[:event][:location]
    @event_entry.phone_number.attributes = p[:event][:phone_number]
    @event_entry.url.attributes          = p[:event][:ci_url]

    @models_that_can_be_completely_blank = [@event_entry.email, @event_entry.person, @event_entry.phone_number, @event_entry.url]
    #  @event_entry must be listed last in this array because it is the last model that should be saved
    @models_that_must_be_valid = [@event_entry.location, @event_entry]  

    @all_linked_models = @models_that_must_be_valid + @models_that_can_be_completely_blank
  end

  def valid_id_and_permissions?
    if not params.has_key?(:id)
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>Event not Found</h2><p>No Event ID was provided</p>"
      return false
    end

    begin
      @event_entry = EventEntry.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>Event not Found</h2><p>Unable to find the Event you are searching for.</p>"
      return false
    end

    #  Restrict access to admins or the user who owns the current contact event entry
    if !@current_user.admin? && (@current_user != @event_entry.owner_user || @event_entry.owner_user == nil)
      flash[:notice] = "<h2>Access Denied</h2><p>You do not have permission to edit this Event.</p>"
      return false
    end
    
    true
  end

end
