class SmsController < ApplicationController
	def get_messages
		data = {}
    user = ApiKey.find_by_key(params[:api_key]).user rescue nil

    unless user.blank?
      api_key_status = User.api_key_status(user)
      messages = Message.find(:all, :conditions => ["sent =? AND user_id =?", 0, user.user_id])

      count = 1
      messages.each do |message|
        data[count] = {}
        data[count]["phone_number"] = message.receiver
        data[count]["message"] = message.content
        message.sent = 1
        message.save
        count = count + 1
      end if (api_key_status.match(/ACTIVE/i))
      
    end
    
		render :text => data.to_json
	end

  def deliver
    if request.post?
      user = User.check_api_key(params[:api_key])
      render :text => "unauthorized" and return if user.blank?
      recipient = params[:recipient]
      message = params[:message]
      
      if recipient.blank?
        render :text => "bad request" and return
      end
      if message.blank?
        render :text => "bad request" and return
      end
      
      data = {}
      data["userid"] = user.user_id
      data["recipient"] = recipient
      data["message"] = message
      Message.save_sms(data)
      render :text => "success" and return
    else
      render :text => "unsupported method" and return
    end
  end
end
