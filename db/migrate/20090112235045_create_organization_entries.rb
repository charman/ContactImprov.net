class CreateOrganizationEntries < ActiveRecord::Migration
  def self.up
    create_table :organization_entries, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :organization_entry_id, :primary_key, :null => false
      t.integer  :version
      t.integer  :owner_user_id
      t.integer  :organization_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.text     :ci_notes
      t.timestamps
    end

    create_table :organization_entry_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :organization_entry_version_id, :primary_key, :null => false
      t.integer  :organization_entry_id
      t.integer  :version
      t.integer  :owner_user_id
      t.integer  :organization_id
      t.integer  :location_id
      t.integer  :email_id
      t.integer  :phone_number_id
      t.integer  :url_id
      t.text     :ci_notes
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :organization_entries
    drop_table :organization_entry_versions
  end
end
