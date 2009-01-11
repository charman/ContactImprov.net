require 'test_helper'

class StudioControllerTest < ActionController::TestCase

  fixtures :users


  def test_should_accept_studio_entry_application
    login_as :quentin
    post :create, 
      :studio_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :studio => { :name => 'newstudio' },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    new_entry = StudioEntry.find(:last)    
    assert_equal users(:quentin),              new_entry.owner_user
    assert_equal 'newdescription',             new_entry.description
    assert_equal 'newstudio',                  new_entry.studio.name
    assert_equal 'newmail@contactimprov.org',  new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal '666-333-9999',               new_entry.phone_number.number
    assert_match /craigharman\.net\/newurl/,   new_entry.url.address
  end

end
