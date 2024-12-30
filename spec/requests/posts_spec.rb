require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:post_obj) { create(:post, user: user) }
  let(:invalid_post_params) { { post: { title: "", content: "" } } }

  def login_user
    post login_path, params: { email: user.email, password: "password123" }
  end
  
  describe "GET /posts" do
    it "exibe a lista de posts" do
      get posts_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Posts")
    end
  end

  describe "GET /posts/:id" do
    
    it "exibe o post" do
      get post_path(post_obj)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post_obj.title)
    end
  end

  describe "GET /posts/new" do
    context "quando o usuário está logado" do
      before { login_user }

      it "exibe o formulário de novo post" do
        get new_post_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "quando o usuário não está logado" do
      it "redireciona para a página de login" do
        get new_post_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /posts" do
    context "quando os dados do post são válidos" do

        before { login_user }

        it "loga o usuário e redireciona para a página inicial" do
            expect(response).to redirect_to(root_path)
            follow_redirect!
            expect(response.body).to include("Login realizado com sucesso!")
        end
    end

    context "quando os dados do post são inválidos" do
        
        it "não loga o usuário e exibe mensagem de erro" do
            post "/login", params: { email: user.email, password: "wrongpassword" }
            expect(response.status).to eq(422)
            expect(response.body).to include("Email ou senha inválidos!")
        end
    end
  end

  describe "GET /posts/:id/edit" do

    context "quando o usuário está logado" do
      before { login_user }
      it "exibe o formulário de edição do post" do
        get edit_post_path(post_obj)
        expect(response).to have_http_status(:ok)
      end
    end

    context "quando o usuário não está logado" do
      it "redireciona para a página de login" do
        get edit_post_path(post_obj)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /posts/:id" do

    context "quando os dados do post são válidos" do
      before { login_user }
      it "atualiza o post e redireciona para a lista de posts" do
        patch post_path(post_obj), params: { post: { title: "Updated title", content: "Updated content" } }
        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(response.body).to include("Post atualizado com sucesso!")
      end
    end

    context "quando os dados do post são inválidos" do
        before { login_user }
      it "não atualiza o post e renderiza o formulário de edição" do
    
        patch post_path(post_obj), params: invalid_post_params
        expect(response).to have_http_status(422)
        expect(flash.now[:alert]).to include("Title can't be blank")
        expect(flash.now[:alert]).to include("Content can't be blank")

      end
    end
  end

  describe "DELETE /posts/:id" do

    context "quando o usuário está logado" do
        before { login_user }
      it "deleta o post e redireciona para a lista de posts" do
        
        delete post_path(post_obj)
        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(response.body).to include("Post deletado com sucesso!")
      end
    end

    context "quando o usuário não está logado" do
      it "redireciona para a página de login" do
        delete post_path(post_obj)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
