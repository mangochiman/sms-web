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
    render :layout => "details"
  end

  def sample_code
    render :layout => "details"
  end

  def contact
    render :layout => "details"
  end

  def my_account
    render :layout => "my_account"
  end
  
end
