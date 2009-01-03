class CreateUserAccountRequests < ActiveRecord::Migration
  def self.up
    create_table :user_account_requests, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :user_account_request_id, :primary_key, :null => false
      t.string   :state, :limit => 12
      t.text     :something_about_contact_improv
      t.text     :existing_entries
      t.text     :ci_notes
      t.integer  :person_id
      t.integer  :email_id
      t.integer  :location_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_account_requests
  end
end
