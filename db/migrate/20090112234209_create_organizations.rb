class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :organization_id, :primary_key, :null => false
      t.integer  :version
      t.string   :name
      t.text     :description
      t.timestamps
    end

    create_table :organization_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :organization_version_id, :primary_key, :null => false
      t.integer  :organization_id
      t.integer  :version
      t.string   :name
      t.text     :description
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :organizations
    drop_table :organization_versions
  end
end
