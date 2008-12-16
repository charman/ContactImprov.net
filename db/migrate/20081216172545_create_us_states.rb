class CreateUsStates < ActiveRecord::Migration
  def self.up
    create_table :us_states, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :us_state_id, :primary_key, :null => false
      t.string   :abbreviation, :limit => 2
      t.string   :name, :limit => 50
      t.string   :underlined_name, :limit => 50
    end
    add_index :us_states, :abbreviation
    add_index :us_states, :name
    add_index :us_states, :underlined_name
  end

  def self.down
    drop_table :us_states
  end
end
