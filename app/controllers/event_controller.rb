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
      @contact_event.owner_user = current_user
      @contact_event.save!
      redirect_to :controller => 'user', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    if not params.has_key?(:id)
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>Event not Found</h2><p>No Event ID was provided</p>"
      return
    end

    begin
      @contact_event = ContactEvent.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      # TODO: Rewrite error message to tell user to contact webmaster
      flash[:notice] = "<h2>Event not Found</h2><p>Unable to find the Event you are searching for.</p>"
      return
    end

    if @contact_event.owner_user != current_user
      flash[:notice] = "<h2>Access Denied</h2><p>You do not have permission to edit this Event.</p>"
      return
    end

    @contact_event.person       ||= Person.new
    @contact_event.email        ||= Email.new
    @contact_event.phone_number ||= PhoneNumber.new
    @contact_event.url          ||= Url.new

    if request.put?
      initialize_event_and_linked_models_from_params(params)

      if event_and_linked_models_valid?
        delete_completely_blank_models
        @contact_event.owner_user = current_user
        @models_that_can_be_completely_blank.each { |m| m.save! if not m.completely_blank? }
        @models_that_must_be_valid.each { |m| m.save! }
        # lemma: @contact_event is the last event to be saved
        redirect_to :controller => 'user', :action => 'index'
      end
    end
  end

  def list
    @events = ContactEvent.find(:all)
  end

  def new
    create_event_and_linked_models
  end


protected

  def create_event_and_linked_models
    @contact_event = ContactEvent.new
    @contact_event.person       = Person.new
    @contact_event.email        = Email.new
    @contact_event.location     = Location.new
    @contact_event.phone_number = PhoneNumber.new
    @contact_event.url          = Url.new
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
    @contact_event.attributes = p[:contact_event]
    @contact_event.person.attributes       = p[:event][:person]
    @contact_event.email.attributes        = p[:event][:email]
    @contact_event.location.attributes     = p[:event][:location]
    @contact_event.phone_number.attributes = p[:event][:phone_number]
    @contact_event.url.attributes          = p[:event][:ci_url]

    @models_that_can_be_completely_blank = [@contact_event.email, @contact_event.person, @contact_event.phone_number, @contact_event.url]
    #  @contact_event must be listed last in this array because it is the last model that should be saved
    @models_that_must_be_valid = [@contact_event.location, @contact_event]  

    @all_linked_models = @models_that_must_be_valid + @models_that_can_be_completely_blank
  end
  

end
