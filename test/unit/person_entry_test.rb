require 'test_helper'

class PersonEntryTest < ActiveSupport::TestCase
  fixtures :person_entries, :users

  def test_acts_as_versioned
    p = PersonEntry.new
    p.owner_user = users(:admin_without_person_entry)
    assert_nil p.version
    assert p.save!
    assert p.version == 1
    assert p.save!    #  Verify that versions_conditions_met? does not fail
  end
 
  def test_should_let_admin_resave_person_entry
    p = PersonEntry.new
    p.owner_user = users(:admin_without_person_entry)
    assert p.save!
    assert p.save!
  end
 
  def test_should_let_non_admin_resave_person_entry
    p = PersonEntry.new
    p.owner_user = users(:non_admin_without_person_entry)
    assert p.save!
    assert p.save!
  end
 
  def test_allow_admins_to_create_multiple_person_entries
    p1 = PersonEntry.new
    p1.owner_user = users(:admin_without_person_entry)
    assert p1.save!
    assert p1.save!
    p2 = PersonEntry.new
    p2.owner_user = users(:admin_without_person_entry)
    assert p2.save!
    assert p2.save!
  end
 
  def test_not_allow_non_admins_to_create_multiple_person_entries
    p1 = PersonEntry.new
    p1.owner_user = users(:non_admin_without_person_entry)
    assert p1.save!
    assert p1.save!
    p2 = PersonEntry.new
    p2.owner_user = users(:non_admin_without_person_entry)
    assert !p2.save
    assert_match /You are already listed in the directory of People/, p2.errors[:base].first
  end
 
end
