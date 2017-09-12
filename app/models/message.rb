class Message < ActiveRecord::Base
  set_table_name :messages
  set_primary_key :message_id

  belongs_to :user, :foreign_key => :user_id
  
  def self.save_sms(data)
    new_message = Message.new
    new_message.user_id = data["userid"]
    new_message.receiver = data["recipient"]
    new_message.content = data["message"]
    new_message.date_sent = Date.today
    new_message.save
  end
  
end
