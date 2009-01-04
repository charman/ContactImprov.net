class CreateEventEntries < ActiveRecord::Migration
  def self.up
    create_table :event_entries, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :event_entry_id, :primary_key, :null => false
      t.integer  :version
      t.string   :title
      t.text     :description
      t.text     :fee_description
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

    create_table :event_entry_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :event_entry_version_id, :primary_key, :null => false
      t.integer  :event_entry_id
      t.integer  :version
      t.string   :title
      t.text     :description
      t.text     :fee_description
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
    drop_table :event_entries
    drop_table :event_entry_versions
  end
end
