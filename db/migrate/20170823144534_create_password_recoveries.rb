class CreatePasswordRecoveries < ActiveRecord::Migration
  def self.up
    create_table :password_recoveries, :primary_key => :password_recovery_id do |t|
      t.integer :user_id
      t.string :password
      t.date :date
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :password_recoveries
  end
end
