class SessionsController < ApplicationController
    def new 
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: I18n.t('sessions.create.success')
      else
        flash.now[:alert] = I18n.t('sessions.create.failure')
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: I18n.t('sessions.destroy.success')
    end

end
