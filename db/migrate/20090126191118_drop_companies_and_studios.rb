class DropCompaniesAndStudios < ActiveRecord::Migration
  def self.up
    drop_table :companies
    drop_table :company_entries
    drop_table :company_entry_versions
    drop_table :company_versions
    drop_table :studio_entries
    drop_table :studio_entry_versions
    drop_table :studio_versions
    drop_table :studios
  end

  def self.down
    #  There's no going back...
  end
end
