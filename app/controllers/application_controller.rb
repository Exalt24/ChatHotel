class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user, :logged_in?

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
            log_in user
            @current_user = user
        end
    end
end

  def logged_in?
    !current_user.nil?
  end

  def current_user?(user)
    user && user == current_user
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || root_url)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :mobile_number ])
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
