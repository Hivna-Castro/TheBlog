require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) } 

  describe "GET /signup" do
    it "show the signup form" do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t('application.users.create.signup'))
    end
  end

  describe "POST /signup" do
    context "when the user's data is valid" do
      it "creates the user and redirects to the homepage" do
        post signup_path, params: { user: { name: "Novo Usuário", email: "novo@user.com", password: "senha123", password_confirmation: "senha123" } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('users.create.success'))
      end
    end

    context "when the user's data is invalid" do
      it "does not create the user and renders the signup form" do
        post signup_path, params: { user: { name: "", email: "invalid_email", password: "123", password_confirmation: "456" } }
        expect(response).to have_http_status(:ok) 
        flash.now[:alert] = I18n.t('users.create.failure', errors: user.errors.full_messages.to_sentence)

      end
    end
  end

  describe "GET /edit" do
    context "when the user is logged in" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "shows the user edit form" do
        get edit_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /users/:id" do
    context "when the user's data is valid" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "updates the user's profile and redirects to the posts page" do
        patch user_path(user), params: { user: { name: "Nome Atualizado", password: "nova_senha123", password_confirmation: "nova_senha123", current_password: "password123" } }
        expect(response).to redirect_to(posts_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('users.update.success'))
      end
    end

    context "when the user's data is invalid" do
      before do
        post login_path, params: { email: user.email, password: "password123" }
      end

      it "does not update the user's profile and renders the edit form" do
        patch user_path(user), params: { user: { name: "", password: "nova_senha123", password_confirmation: "nova_senha123" } }
        expect(response).to have_http_status(422)
        expect(response.body).to include(I18n.t('users.update.missing_current_password'))
      end
    end
  end

  describe "POST /forgot_password" do
    context "when the email is valid" do
      it "generates a password reset token" do
        post forgot_password_users_path, params: { email: user.email }

        expect(response).to have_http_status(:found) 
        expect(flash[:notice]).to eq(I18n.t('users.forgot_password.success'))
      end
    end

    context "when the email is not found" do
      it "does not generate a token and displays an error message" do
        post forgot_password_users_path, params: { email: "nao_existe@user.com" }

        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to eq(I18n.t('users.forgot_password.failure'))
      end
    end
  end
end
