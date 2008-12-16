class CreateStudios < ActiveRecord::Migration
  def self.up
    create_table :studios, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :studio_id, :primary_key, :null => false
      t.integer  :version
      t.string   :name
      t.timestamps
    end

    create_table :studio_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :studio_version_id, :primary_key, :null => false
      t.integer  :studio_id
      t.integer  :version
      t.string   :name
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :studios
    drop_table :studio_versions
  end
end
