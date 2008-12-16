class CreateCountryNames < ActiveRecord::Migration
  def self.up
    create_table :country_names, :id => false, :options => "auto_increment = 15000" do |t|
      t.column :country_name_id, :primary_key, :null => false
      t.string :iso_3166_1_a2_code, :limit => 2
      t.string :english_name
      t.string :underlined_english_name
    end
    add_index :country_names, :iso_3166_1_a2_code
    add_index :country_names, :english_name
    add_index :country_names, :underlined_english_name
  end

  def self.down
    drop_table :country_names
  end
end
