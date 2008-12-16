class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :user_id, :primary_key, :null => false
      t.string   :email
      t.integer  :person_id
      t.boolean  :admin, :default => false
      t.string   :state, :limit => 12
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :password_reset_code, :limit => 40
      t.string   :activation_code, :limit => 40
      t.datetime :activated_at
      t.datetime :deleted_at
      t.datetime :last_login_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.timestamps
    end
    add_index :users, :email
    add_index :users, :person_id
    add_index :users, :state
    add_index :users, :password_reset_code
    add_index :users, :activation_code
  end

  def self.down
    drop_table :users
  end
end
