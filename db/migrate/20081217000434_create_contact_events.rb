class CreateContactEvents < ActiveRecord::Migration
  def self.up
    create_table :contact_events, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :contact_event_id, :primary_key, :null => false
      t.integer  :version
      t.string   :title
      t.string   :subtitle
      t.text     :description
      t.date     :start_date
      t.date     :end_date
      t.integer  :owner_user_id
      t.integer  :person_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.integer  :company_id
      t.integer  :studio_id
      t.text     :ci_notes
      t.timestamps
    end

    create_table :contact_event_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :contact_event_version_id, :primary_key, :null => false
      t.integer  :contact_event_id
      t.integer  :version
      t.string   :title
      t.string   :subtitle
      t.text     :description
      t.date     :start_date
      t.date     :end_date
      t.integer  :owner_user_id
      t.integer  :person_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.integer  :company_id
      t.integer  :studio_id
      t.text     :ci_notes
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :contact_events
    drop_table :contact_event_versions
  end
end
