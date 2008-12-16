class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :email_id, :primary_key, :null => false
      t.integer  :version
      t.integer  :for_entity_id
      t.integer  :position
      t.string   :address
      t.timestamps
    end
    add_index :emails, :for_entity_id
    add_index :emails, :address
    
    create_table :email_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :email_version_id, :primary_key, :null => false
      t.integer  :email_id
      t.integer  :version
      t.integer  :for_entity_id
      t.integer  :position
      t.string   :address
      t.datetime :updated_at
    end
    add_index :email_versions, :email_id
    add_index :email_versions, :for_entity_id
    add_index :email_versions, :address
  end

  def self.down
    drop_table :emails
    drop_table :email_versions
  end
end
