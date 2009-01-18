class AddStudioSpaceField < ActiveRecord::Migration
  def self.up
    add_column :organization_entries, :studio_space, :boolean, :after => 'teaches_contact'
    add_column :organization_entry_versions, :studio_space, :boolean, :after => 'teaches_contact'
  end

  def self.down
    remove_column :organization_entries, :studio_space
    remove_column :organization_entry_versions, :studio_space
  end
end
