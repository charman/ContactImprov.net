class CreateJamEntries < ActiveRecord::Migration
  def self.up
    create_table :jam_entries, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :jam_entry_id, :primary_key, :null => false
      t.integer  :version
      t.string   :title
      t.text     :description
      t.text     :schedule
      t.text     :cost
      t.integer  :owner_user_id
      t.integer  :person_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.integer  :studio_id
      t.text     :ci_notes
      t.timestamps
    end

    create_table :jam_entry_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :jam_entry_version_id, :primary_key, :null => false
      t.integer  :jam_entry_id
      t.integer  :version
      t.string   :title
      t.text     :description
      t.text     :schedule
      t.text     :cost
      t.integer  :owner_user_id
      t.integer  :person_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.integer  :studio_id
      t.text     :ci_notes
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :jam_entries
    drop_table :jam_entry_versions
  end
end
