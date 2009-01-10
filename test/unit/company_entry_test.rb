require 'test_helper'

class CompanyEntryTest < ActiveSupport::TestCase
  fixtures :company_entries

  def test_acts_as_versioned
    c = CompanyEntry.new
    assert_nil c.version
    assert c.save!
    assert c.version == 1
    assert c.save!    #  Verify that versions_conditions_met? does not fail
  end
 
end
