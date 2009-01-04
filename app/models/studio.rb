class Studio < ActiveRecord::Base
  include SanitizeAccessibleAttributes

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :name

  validates_presence_of :name, :message => "for Studio can't be blank"

  def before_save
    sanitize_attributes
  end
    
  def version_condition_met?
    name_changed?
  end

end
