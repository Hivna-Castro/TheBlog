require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) } 

  describe "GET /signup" do
    it "exibe o formulário de cadastro" do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cadastro")
    end
  end

  describe "POST /signup" do
    context "quando os dados do usuário são válidos" do
      it "cria o usuário e redireciona para a página inicial" do
        post signup_path, params: { user: { name: "Novo Usuário", email: "novo@user.com", password: "senha123", password_confirmation: "senha123" } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Conta criada com sucesso!")
      end
    end

    context "quando os dados do usuário são inválidos" do
      it "não cria o usuário e renderiza o formulário de cadastro" do
        post signup_path, params: { user: { name: "", email: "invalid_email", password: "123", password_confirmation: "456" } }
        expect(response).to have_http_status(:ok) 
    
        expect(flash.now[:alert]).to include("Name can't be blank")
        expect(flash.now[:alert]).to include("Email is invalid")
        expect(flash.now[:alert]).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe "GET /edit" do
    context "quando o usuário está logado" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "exibe o formulário de edição do usuário" do
        get edit_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "quando o usuário não está logado" do
      it "redireciona para a página de login" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /users/:id" do
    context "quando os dados do usuário são válidos" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "atualiza o perfil do usuário e redireciona para a página de posts" do
        patch user_path(user), params: { user: { name: "Nome Atualizado", password: "nova_senha123", password_confirmation: "nova_senha123", current_password: "password123" } }
        expect(response).to redirect_to(posts_path)
        follow_redirect!
        expect(response.body).to include("Perfil atualizado com sucesso.")
      end
    end

    context "quando os dados do usuário são inválidos" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "não atualiza o perfil do usuário e renderiza o formulário de edição" do
        patch user_path(user), params: { user: { name: "", password: "nova_senha123", password_confirmation: "nova_senha123" } }
        expect(response).to have_http_status(422)
        expect(response.body).to include("Senha atual é obrigatória para alterar a senha.")
      end
    end
  end

  describe "POST /forgot_password" do
    context "quando o email é válido" do
      it "gera um token de reset de senha" do
        post forgot_password_users_path, params: { email: user.email }

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq("E-mail de redefinição enviado com sucesso.")
      end
    end

    context "quando o email não é encontrado" do
      it "não gera token e exibe mensagem de erro" do
        post forgot_password_users_path, params: { email: "nao_existe@user.com" }

        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to eq("Usuário não encontrado.")
      end
    end
  end
end
