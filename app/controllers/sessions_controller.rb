class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in, except: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      if (user.role == "owner")
        redirect_to admin_index_path
      else
        redirect_to users_menu_path(id: 0)
      end
    else
      flash[:error] = "Your login attempt was invalid. Please retry."
      redirect_to root_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to root_path
  end
end
