class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_role, :primary_key => :user_role_id do |t|
      t.integer :user_id
      t.string :role
      t.integer :sort_weight
      t.timestamps
    end
  end

  def self.down
    drop_table :user_role
  end
end
