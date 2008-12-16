class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :url_id, :primary_key, :null => false
      t.integer  :version
      t.integer  :for_entity_id
      t.string   :address
      t.timestamps
    end
    add_index :urls, :for_entity_id
    
    create_table :url_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :url_version_id, :primary_key, :null => false
      t.integer  :url_id
      t.integer  :version
      t.integer  :for_entity_id
      t.string   :address
      t.datetime :updated_at
    end
    add_index :url_versions, :url_id
    add_index :url_versions, :for_entity_id
  end

  def self.down
    drop_table :urls
    drop_table :url_versions
  end
end
