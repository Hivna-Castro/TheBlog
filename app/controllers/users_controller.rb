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
          flash.now[:alert] = I18n.t('users.update.current_password_missing')
          render :edit, status: :unprocessable_entity
          return
        elsif !@user.authenticate(user_params[:current_password])
          flash.now[:alert] = I18n.t('users.update.current_password_incorrect')
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

      user = User.find_by(email: params[:email])

      if user.nil?
        flash[:alert] = I18n.t('users.forgot_password.failure')
        return render :forgot_password_form
      end

      token = user.generate_password_reset_token
      reset_link = reset_password_form_users_url(token: token )

      result = Users::Organizers::SendEmailResetPassword.call(email: params[:email], user: user, reset_link: reset_link, token: token)

      if result.success?
        flash[:notice] = result.message
        redirect_to login_path
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

      @user = User.find_by(reset_password_token: params[:token])

      if @user.nil? || !@user.password_reset_token_valid?
        flash[:alert] = I18n.t('users.reset_password.invalid_token')
        redirect_to login_path
        return
      end

      if params[:password] != params[:password_confirmation]
        flash[:alert] = I18n.t('users.reset_password.password_mismatch')
        @token = params[:token] 
        render :reset_password_form
        return
      end
    
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        @user.clear_password_reset_token!
        flash[:notice] = I18n.t('users.reset_password.success')
        redirect_to login_path
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        @token = params[:token]
        render :reset_password_form
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
    end

end
