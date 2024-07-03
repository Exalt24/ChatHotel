class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        if user.activated?
          log_in user
          params[:remember_me] == "1" ? remember(user) : forget(user)
          if user.admin?
            redirect_to admin_path
          else
            redirect_back_or user
          end
        else
          message = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end
      else
        flash.now[:error] = "Invalid email or password."
        render "new"
      end
    end

    def destroy
      log_out if logged_in?
      flash[:success] = "Logged out successfully."
      redirect_to root_path
    end
end
