class CreateApiKeys < ActiveRecord::Migration
  def self.up
    create_table :api_keys, :primary_key => :api_key_id do |t|
      t.integer :user_id
      t.date :expiry_date
      t.string :key
      t.timestamps
    end
  end

  def self.down
    drop_table :api_keys
  end
end
