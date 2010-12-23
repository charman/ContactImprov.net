class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions, :options => "auto_increment = 15000" do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :user_sessions, :session_id
    add_index :user_sessions, :updated_at
  end

  def self.down
    drop_table :user_sessions
  end
end
