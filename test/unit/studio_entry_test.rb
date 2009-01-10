require 'test_helper'

class StudioEntryTest < ActiveSupport::TestCase
  fixtures :studio_entries

  def test_acts_as_versioned
    s = StudioEntry.new
    assert_nil s.version
    assert s.save!
    assert s.version == 1
    assert s.save!    #  Verify that versions_conditions_met? does not fail
  end
 
end
