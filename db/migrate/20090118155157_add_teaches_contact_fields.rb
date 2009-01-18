class AddTeachesContactFields < ActiveRecord::Migration
  def self.up
    add_column :person_entries, :teaches_contact, :boolean, :after => 'description'
    add_column :person_entry_versions, :teaches_contact, :boolean, :after => 'description'

    add_column :organization_entries, :teaches_contact, :boolean, :after => 'version'
    add_column :organization_entry_versions, :teaches_contact, :boolean, :after => 'version'
  end

  def self.down
    remove_column :person_entries, :teaches_contact
    remove_column :person_entry_versions, :teaches_contact

    remove_column :organization_entries, :teaches_contact
    remove_column :organization_entry_versions, :teaches_contact
  end
end
