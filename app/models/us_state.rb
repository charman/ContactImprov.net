class UsState < ActiveRecord::Base
#  has_many :locations

  #  The validity of a UsState object should be checked by calling valid?, and not by
  #   attempting to save the object.
  #  This validation only approves UsState objects where the name of the state
  #   is in the database - which effectively prevents us from adding new UsState objects,
  #   since they will fail validation.  It's something of a Catch-22.  If you need to add a
  #   UsState, you should do so using MySQL.
  validates_each :name do |model, attr, value|
    if !UsState.find_by_name_or_abbreviation(value)
      model.errors.add_to_base("'#{value}' is not the name of a US state")
    end
  end


  def self.find_by_name_or_abbreviation(noa)
    by_name = find_by_name(noa)
    if by_name
      return by_name
    else
      by_abbreviation = find_by_abbreviation(noa)
      if by_abbreviation
        by_abbreviation
      else
        nil
      end
    end
  end

end
