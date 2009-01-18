class ChangeUserPersonEntryRelationship < ActiveRecord::Migration
  def self.up
    remove_column :person_entries, :is_owner_user

    add_column :users, :own_person_entry_id, :integer, :after => 'person_id'
  end

  def self.down
    add_column :person_entities, :is_owner_user, :boolean, :after => 'owner_user_id'
    
    remove_column :users, :own_person_entry_id
  end
end
