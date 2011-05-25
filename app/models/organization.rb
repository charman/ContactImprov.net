class Organization < ActiveRecord::Base
  include AccessibleAttributeEncoding

  has_one :organization_entry

  acts_as_versioned
  self.non_versioned_columns << 'created_at'

  attr_accessible :name, :description

  before_save :sanitize_attributes!
  
  validates_presence_of :name, :message => "for Organization can't be blank"


  def version_condition_met?
    name_changed? || description_changed?
  end

end
