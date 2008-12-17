class Location < ActiveRecord::Base
#  has_one :contacts_application
#  has_one :entity, :as => :resource
#  has_one :user, :foreign_key => 'subscriber_address_id'
#  has_one :user_account_request
  has_one :contact_event
  belongs_to :country_name
  belongs_to :us_state
  
  acts_as_mappable
  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :street_address_line_1, :street_address_line_2, :city_name, :region_name, 
                  :us_state_id, :postal_code, :country_name_id

  delegate :iso_3166_1_a2_code, :to => "country_name.nil? ? false : country_name"

  validates_presence_of :city_name
  validate :validate_country_name_and_us_state

  #  Verify that this Location object is linked to a valid CountryName and (if in US) UsState objects.
  #
  #  TODO: Potential bug - if initialize_from_params is called, and then Location is later linked to
  #         valid CountryName and UsState objects, validation will still fail.
  def validate_country_name_and_us_state
    #  If initialize_from_params was called, then it already checked that Location.country_name and (if in
    #   US) Location.us_state were non-nil.  initialize_from_params also saved error messages *with the
    #   user-provided invalid form values* to the @param_initialization_errors array.  We want the validation
    #   error messages to tell the user what invalid value they entered, not just that they entered some 
    #   unknown invalid value.  The user may have fat-fingered the country name (an error on their end), or 
    #   they may have entered an alternate spelling for the country name that is not in our database (an error
    #   on our end).
    if @param_initialization_errors  && !@param_initialization_errors.empty?
      @param_initialization_errors.each { |param, error_message| errors.add(param, error_message) }
    else
      #  If initialize_from_params was *not* called, then we still validate the country_name and us_state links.
      #   This is equivalent to validating these fields using:
      #     validates_presence_of :country_name
      #     validates_presence_of :us_state_name, :if => :is_in_usa?
      if !self.country_name
        errors.add(:country_name, "Unknown country name")
      end
      if self.is_in_usa? && !self.us_state
        errors.add(:us_state, "Unknown US State name")
      end
    end
  end

  def version_condition_met?
    street_address_line_1_changed? || street_address_line_2_changed? || city_name_changed? || region_name_changed? || 
      us_state_id_changed? || postal_code_changed? || country_name_id_changed? || 
      lat_changed? || lng_changed? || geocode_precision_changed?
  end

  def after_save
    #  Create an entity object for the current object, if it does not already exist
#    if !self.entity
#      e = Entity.new
#      e.resource = self
#      e.save!
#    end  
  end

  def attributes_that_differ_from(other_version)
    some_column_names = Location.column_names
    some_column_names.delete('location_id')
    some_column_names.delete('version')

    some_column_names.find_all { |attribute_name| 
      self.send(attribute_name) != other_version.send(attribute_name)
    }
  end

  def before_save
    self.geocode
    true  #  We always return true, so that the object is saved regardless of whether or not geocoding succeeded
  end

  def city_state_country
    if self.is_in_usa?
      "#{self.city_name}, #{self.us_state.abbreviation} #{self.country_name.english_name}"
    else
      "#{self.city_name}, #{self.country_name.english_name}"
    end
  end

  def english_country_name
    if country_name
      country_name.english_name
    else
      ''
    end
  end

  def geocode
    geoloc = GeoKit::GeoLoc.new
    geoloc.city              = self.city_name
    geoloc.country_code      = self.iso_3166_1_a2_code
    geoloc.street_address    = self.street_address_line_1
    if (!self.street_address_line_2.blank?)
      geoloc.street_address += ", #{self.street_address_line_2}"
    end
    geoloc.zip               = self.postal_code
    if self.is_in_usa?
      geoloc.state           = self.us_state.name
    end
    new_geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(geoloc)
    
    if new_geoloc.success
      self.lat               = new_geoloc.lat
      self.lng               = new_geoloc.lng
      self.geocode_precision = new_geoloc.precision
    else
      self.lat               = nil
      self.lng               = nil
      self.geocode_precision = nil
    end
    
    new_geoloc.success
  end
  
  def human_readable_attribute(attribute_name)
    case attribute_name
    when 'us_state_id'
      if self.is_in_usa?
        self.us_state.name
      else
        ''
      end
    when 'country_name_id'
      if self.country_name
        self.country_name.english_name
      else
        ''
      end
    else
      self.send(attribute_name)
    end
  end

  #  TODO: This method introduces some coupling between the model and the view.
  #        This function cannot be moved to a helper file because the @param_initialization_errors 
  #         member variable is used by validate_country_name_and_us_state.
  def initialize_from_params(params)
    #  This method verifies that the user has provided us with a valid country name and, if in the US, a
    #   valid US state name.  If either value is invalid, we save an error message *with the user's invalid
    #   form data* (e.g. a misspelled country name) to the @param_initialization_errors.
    #  See validate_country_name_and_us_state for more details.
    #
    #  TODO: I tried calling errors.add_to_base() from this function, but none of the errors
    #         that I added to the model caused validation to fail - so instead, I am using 
    #         the admitted hack of storing my error messages in @param_initialization_errors,
    #         and then checking for the presence of those error messages with 
    #         validate_country_name_and_us_state.  There *has* to be a better way to do this.
    #
    @param_initialization_errors = Hash.new

    self.street_address_line_1 = params[:street_address_line_1]
    self.street_address_line_2 = params[:street_address_line_2]
    self.city_name             = params[:city_name]
    self.postal_code           = params[:postal_code]

    self.country_name = CountryName.find_by_english_name_or_altname(params[:country_name][:english_name])
    if !self.country_name
      @param_initialization_errors[:country_name] = "'#{params[:country_name][:english_name]}' is not the name of a country in our database"
    end
 
    if self.is_in_usa?
      self.us_state = UsState.find_by_name_or_abbreviation(params[:us_state][:name])
      if !self.us_state
        @param_initialization_errors[:us_state] = "'#{params[:us_state][:name]}' is not the name of a US state"
      end
    else 
      self.region_name = params[:us_state][:name]
    end
  end

  def is_in_usa?
    if self.country_name && self.country_name.is_usa?
      return true
    else
      return false
    end
  end

  def state_abbreviation_or_region_name
    if self.is_in_usa?
      self.us_state.abbreviation
    else
      self.region_name
    end
  end

  def state_name_or_region_name
    if self.is_in_usa?
      self.us_state.name
    else
      self.region_name
    end
  end

end