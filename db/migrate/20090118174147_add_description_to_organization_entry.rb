class AddDescriptionToOrganizationEntry < ActiveRecord::Migration
  def self.up
    add_column :organization_entries, :description, :text, :after => 'version'
    add_column :organization_entry_versions, :description, :text, :after => 'version'
  end

  def self.down
    remove_column :organization_entries, :description
    remove_column :organization_entry_versions, :description
  end
end
