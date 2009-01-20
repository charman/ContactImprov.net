require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  fixtures :users


  def test_should_accept_company_entry_application
    login_as :quentin
    post :create, 
      :company_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :company => { :name => 'newcompany' },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    new_entry = CompanyEntry.find(:last)    
    assert_equal users(:quentin),              new_entry.owner_user
    assert_equal 'newdescription',             new_entry.description
    assert_equal 'newcompany',                 new_entry.company.name
    assert_equal 'newmail@contactimprov.org',  new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal '666-333-9999',               new_entry.phone_number.number
    assert_match /craigharman\.net\/newurl/,   new_entry.url.address
  end

end
