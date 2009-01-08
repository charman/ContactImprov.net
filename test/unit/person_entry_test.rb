require 'test_helper'

class PersonEntryTest < ActiveSupport::TestCase
  fixtures :person_entries

  def test_acts_as_versioned
    p = PersonEntry.new
    assert_nil p.version
    assert p.save!
    assert p.version == 1
    assert p.save!    #  Verify that versions_conditions_met? does not fail
  end
 
end
