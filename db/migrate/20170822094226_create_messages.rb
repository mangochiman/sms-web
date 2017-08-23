class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :primary_key => :message_id do |t|
      t.string :user_id
      t.string :receiver
      t.date :date_sent
      t.text :content
      t.integer :sent, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
