class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts, :primary_key => :contact_id do |t|
      t.string :author
      t.string :email
      t.string :subject
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
