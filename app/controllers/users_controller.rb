class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id  
        redirect_to root_path, notice: "Conta criada com sucesso!"
      else
         puts "Erro ao criar o usuário: #{@user.errors.full_messages.join(', ')}"
        render :new
      end
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
    
      # Valida a senha atual apenas se o usuário estiver tentando alterar a senha
      if user_params[:password].present? || user_params[:password_confirmation].present?
        if user_params[:current_password].blank?
          flash.now[:alert] = "Senha atual é obrigatória para alterar a senha."
          render :edit, status: :unprocessable_entity
          return
        elsif !@user.authenticate(user_params[:current_password])
          flash.now[:alert] = "Senha atual não está correta."
          render :edit, status: :unprocessable_entity
          return
        end
      end
    
      # Atualiza o usuário
      if @user.update(user_params.except(:current_password))
        redirect_to posts_path, notice: "Perfil atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
    end

end
