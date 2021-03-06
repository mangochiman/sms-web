class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :primary_key => :user_id do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :password
      t.string :salt
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
