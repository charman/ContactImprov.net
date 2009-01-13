require 'test_helper'

class OrganizationEntryTest < ActiveSupport::TestCase
  fixtures :organization_entries

  def test_acts_as_versioned
    o = OrganizationEntry.new
    assert_nil o.version
    assert o.save!
    assert o.version == 1
    assert o.save!    #  Verify that versions_conditions_met? does not fail
  end
 
end
