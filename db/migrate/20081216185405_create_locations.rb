class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :location_id, :primary_key, :null => false
      t.integer  :version
      t.string   :street_address_line_1
      t.string   :street_address_line_2
      t.string   :city_name
      t.string   :region_name
      t.integer  :us_state_id
      t.string   :postal_code
      t.integer  :country_name_id
      t.float    :lat
      t.float    :lng
      t.string   :geocode_precision, :limit => 10
      t.timestamps
    end
    add_index :locations, :us_state_id
    add_index :locations, :country_name_id

    create_table :location_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :location_version_id, :primary_key, :null => false
      t.integer  :location_id
      t.integer  :version
      t.string   :street_address_line_1
      t.string   :street_address_line_2
      t.string   :city_name
      t.string   :region_name
      t.integer  :us_state_id
      t.string   :postal_code
      t.integer  :country_name_id
      t.float    :lat
      t.float    :lng
      t.string   :geocode_precision, :limit => 10
      t.datetime :updated_at
    end
    add_index :location_versions, :location_id
    add_index :location_versions, :us_state_id
    add_index :location_versions, :country_name_id
  end

  def self.down
    drop_table :locations
    drop_table :location_versions
  end
end
