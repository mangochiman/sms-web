class PagesController < ApplicationController
  def home
    
  end

  def documentation
    render :layout => "details"
  end

  def sign_up
    if request.post?
      password = params[:password]
      password_confirm = params[:confirm_password]

      if (password != password_confirm)
        flash[:error] = "Password Mismatch"
        redirect_to("/sign_up") and return
      end
      user = User.new_user(params)

      if user.save
        api_key = ApiKey.new_api_key(user)
        api_key.save

        flash[:notice] = "You have created your account. You may now login. Your API key is <br />"
        flash[:notice] += " <b id='copy' onclick='CopyToClipboard(\"copy\")'>#{user.api_key}</b><br />"
        flash[:notice] += "Keep it safe. We have also sent it to your email address"
        redirect_to("/sign_up") and return
      else
        flash[:error] = user.errors.full_messages.join('<br />')
        redirect_to("/sign_up") and return
      end
    end
    render :layout => "details"
  end


  def login
    if request.post?
      user = User.find_by_username(params['username'])
      logged_in_user = User.authenticate(params[:username], params[:password])

      if logged_in_user
        session[:user] = user
        redirect_to("/my_account") and return
      else
        flash[:error] = "Invalid username or password"
        redirect_to("/login") and return
      end
    end
    render :layout => "details"
  end

  def sample_code
    render :layout => "details"
  end

  def contact
    if request.post?
      contact = Contact.new
      contact.author = params[:name]
      contact.email = params[:email]
      contact.message = params[:message]

      passed_params = {
        "receiver" => "webtechmw@gmail.com",
        "message" => params[:message],
        "subject" => "Client Query",
        "author_name" => params[:name],
        "author_email" => params[:email]
      }

      if (contact.save)
        Contact.send_email(passed_params)
        flash[:notice] = "Your message is sent. Thank you for your feedback."
        redirect_to("/") and return
      else
        flash[:error] = "Failed to send your message. Try again"
        redirect_to("/contact") and return
      end
    end
    
    render :layout => "details"
  end

  def my_account
    @user = session[:user]
    render :layout => "my_account"
  end

  def sms_web
    if request.post?
      phone_numbers = params[:phone_numbers].split(',').collect{|pn|pn.squish}.uniq
      token = params[:token].squish
      message = params[:message]
      user = User.check_api_key(token)

      unless user.blank?
        phone_numbers.each do |phone_number|
          recipient = phone_number
          data = {}
          data["userid"] = user.user_id
          data["recipient"] = recipient
          data["message"] = message
          Message.save_sms(data)
        end
        flash[:notice] = "Message sent"
      else
        flash[:error] = "API token is not valid"
      end
      
      redirect_to("/sms_web") and return
    end
    render :layout => "details"
  end
  
  def logout
    reset_session
    redirect_to("/") and return
  end

  def change_password
    @user = session[:user]
    
    if request.post?
      if (User.authenticate(@user.username, params[:old_password]))
        if (params[:new_password] == params[:confirm_password])
          @user.password = User.encrypt(params[:new_password], @user.salt)
          @user.save
          flash[:notice] = "You have successfully updated your password. Your new password is <b>#{params[:new_password]}</b>"
          redirect_to("/my_account") and return
        else
          flash[:error] = "Unable to save. New Password and Confirmation password does not match"
          redirect_to("/change_password") and return
        end
      else
        flash[:error] = "Unable to save. Old password is not correct"
        redirect_to("/change_password") and return
      end
    end

    render :layout => "my_account"
  end

  def recover_password
    if request.post?
      user =  User.find_by_email(params[:email])
      activation_link = "http://smsapi.ninja/activate_password/#{user.api_key}"
      new_password = User.random_string(10)
      
      password_recovery = PasswordRecovery.new
      password_recovery.user_id = user.user_id
      password_recovery.date = Date.today
      password_recovery.password = new_password
      password_recovery.save
      
      passed_params = {
        "receiver" => params[:email],
        "message" => "Your password has been recovered. New password is #{new_password}. Click #{activation_link} to activate it. The link is valid for 48 hrs",
        "subject" => "Password Recovery",
        "author_name" => "WebTech++",
        "author_email" => "webtechmw@gmail.com"
      }
      User.send_email(passed_params)
      flash[:notice] = "Your message is sent"
      redirect_to("/") and return
      #raise user.inspect
    end
    render :layout => "details"
  end

  def activate_password
    api_key = params[:api_key]
    user = User.find_by_api_key(api_key)
    unless user.blank?
      password_recovery = PasswordRecovery.find(:last, :conditions => ["user_id =? AND voided = ?", user.user_id, 0])
      unless password_recovery.blank?
        new_password = password_recovery.password
        user.password = User.encrypt(new_password, user.salt)
        user.save
        password_recovery.voided = 1
        password_recovery.save
        flash[:notice] = "You have successfully reset your password. You can now login with the new password"
        redirect_to("/login") and return
      end
    else
      flash[:error] = "Something went wrong"
      redirect_to("/login") and return
    end
  end

  def verify_api_aunthenticity
    api_key = params[:api_key]
    user = User.find_by_api_key(api_key)
    data = {}
    #sleep(10)
    unless user.blank?
      data["username"] = user.username
      data["first_name"] = user.first_name
      data["last_name"] = user.last_name
      data["phone_number"] = user.phone_number
      data["email"] = user.email
      data["created_at"] = user.created_at.to_date.strftime("%d/%b/%Y")
      data["api_key_status"] = User.api_key_status(user)
      data["api_expiry_date"] = User.api_key_expiry_date(user)
      data["api_key"] = api_key
    end

    render :text => data.to_json
  end

  def check_api_key_status
    api_key = params[:api_key]
    user = ApiKey.find_by_key(api_key).user rescue nil
    data = {}
    
    unless user.blank?
      data["username"] = user.username
      data["first_name"] = user.first_name
      data["last_name"] = user.last_name
      data["phone_number"] = user.phone_number
      data["email"] = user.email
      data["created_at"] = user.created_at.to_date.strftime("%d/%b/%Y")
      data["api_key_status"] = User.api_key_status(user)
      data["api_expiry_date"] = User.api_key_expiry_date(user)
      data["api_key"] = api_key
    end

    render :text => data.to_json
  end
  
end

