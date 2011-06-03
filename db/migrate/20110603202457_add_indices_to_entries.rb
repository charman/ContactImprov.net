class AddIndicesToEntries < ActiveRecord::Migration
  def self.up
    add_index :event_entries, :start_date
    add_index :event_entries, :end_date

    add_index :event_entries, :location_id
    add_index :jam_entries, :location_id
    add_index :organization_entries, :location_id
    add_index :person_entries, :location_id
  end

  def self.down
  end
end
