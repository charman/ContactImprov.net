class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :phone_number_id, :primary_key, :null => false
      t.integer  :version
      t.integer  :for_entity_id
      t.string   :number
      t.timestamps
    end
    add_index :phone_numbers, :for_entity_id

    create_table :phone_number_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :phone_number_version_id, :primary_key, :null => false
      t.integer  :phone_number_id
      t.integer  :version
      t.integer  :for_entity_id
      t.string   :number
      t.datetime :updated_at
    end
    add_index :phone_number_versions, :phone_number_id
    add_index :phone_number_versions, :for_entity_id
  end

  def self.down
    drop_table :phone_numbers
    drop_table :phone_number_versions
  end
end
