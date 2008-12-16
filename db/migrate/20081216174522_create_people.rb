class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :person_id, :primary_key, :null => false
      t.integer  :version
      t.string   :first_name
      t.string   :last_name
      t.timestamps
    end

    create_table :person_versions, :id => false, :options => "auto_increment = 15000" do |t|
      t.column   :person_version_id, :primary_key, :null => false
      t.integer  :persion_id
      t.integer  :version
      t.string   :first_name
      t.string   :last_name
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :people
    drop_table :person_versions
  end
end
