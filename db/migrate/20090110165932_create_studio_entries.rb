class CreateStudioEntries < ActiveRecord::Migration
  def self.up
    create_table :studio_entries, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :studio_entry_id, :primary_key, :null => false
      t.integer  :version
      t.integer  :owner_user_id
      t.integer  :studio_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.integer  :studio_id
      t.text     :ci_notes
      t.timestamps
    end

    create_table :studio_entry_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :studio_entry_version_id, :primary_key, :null => false
      t.integer  :studio_entry_id
      t.integer  :version
      t.integer  :owner_user_id
      t.integer  :studio_id
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
    drop_table :studio_entries
    drop_table :studio_entry_versions
  end
end
