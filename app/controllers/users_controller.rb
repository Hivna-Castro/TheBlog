class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create, :forgot_password_form, :forgot_password, :reset_password_form, :reset_password]

    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id  
        redirect_to root_path, notice: I18n.t('users.create.success')
      else
        flash.now[:alert]= I18n.t('users.create.failure', errors: @user.errors.full_messages.to_sentence)
        render :new
      end
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
    
      if user_params[:password].present? || user_params[:password_confirmation].present?
        if user_params[:current_password].blank?
          flash.now[:alert] = I18n.t('users.update.missing_current_password')
          render :edit, status: :unprocessable_entity
          return
        elsif !@user.authenticate(user_params[:current_password])
          flash.now[:alert] = I18n.t('users.update.incorrect_current_password')
          render :edit, status: :unprocessable_entity
          return
        end
      end
    
      if @user.update(user_params.except(:current_password))
        redirect_to posts_path, notice: I18n.t('users.update.success')
      else
        flash.now[:alert] = I18n.t('users.update.failure', errors: @user.errors.full_messages.join(', '))
        render :edit, status: :unprocessable_entity
      end
    end
  
    def forgot_password_form
      render :forgot_password_form
    end

    def forgot_password
      result = Users::Interactors::GeneratePasswordResetToken.call(email: params[:email])

      if result.success?
        flash[:notice] = result.message
        render :forgot_password_form
      else
        flash[:alert] = result.error
        render :forgot_password_form
      end
    end

    def reset_password_form
      @token = params[:token]
      render :reset_password_form
    end

    def reset_password
      result = Users::Interactors::ResetPassword.call(
        token: params[:token],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )

      if result.success?
        redirect_to login_path, notice: result.message
      else
        flash[:alert] = result.error
        @token = params[:token]
        render :reset_password
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
    end

end
