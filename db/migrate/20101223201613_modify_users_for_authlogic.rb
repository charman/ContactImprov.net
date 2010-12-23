class ModifyUsersForAuthlogic < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string, :null => false, :after => 'remember_token_expires_at'
    add_column :users, :login_count, :integer, :default => 0, :null => false, :after => 'persistence_token'
    add_column :users, :last_request_at, :datetime, :after => 'login_count'
    add_column :users, :current_login_at, :datetime, :after => 'last_request_at'
    add_column :users, :last_login_ip, :string, :after => 'current_login_at'
    add_column :users, :current_login_up, :string, :after => 'last_login_ip'

    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
  end
end
