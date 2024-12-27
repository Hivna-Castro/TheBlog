class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def require_login
      unless logged_in?
        flash[:alert] = "Você precisa estar logado para acessar essa página."
        redirect_to login_path
      end
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      !!current_user
    end
end
