class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :company_id, :primary_key, :null => false
      t.integer  :version
      t.string   :name
      t.timestamps
    end

    create_table :company_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :company_version_id, :primary_key, :null => false
      t.integer  :company_id
      t.integer  :version
      t.string   :name
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :companies
    drop_table :company_versions
  end
end
