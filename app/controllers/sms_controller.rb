class SmsController < ApplicationController
	def get_messages
		data = {}
    
    messages = Message.find(:all, :conditions => ["sent =?", 0])
    count = 1
    messages.each do |message|
      data[count] = {}
      data[count]["phone_number"] = message.receiver
      data[count]["message"] = message.content
      count = count + 1
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
