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
            expect(response.body).to include(I18n.t('sessions.create.success'))
        end

        it "cria o post e redireciona para a lista de posts" do
          post_params = { post: { title: "Novo Post", content: "Conteúdo do post" } }
          post posts_path, params: post_params
          expect(response).to have_http_status(302)
          follow_redirect! 
          expect(response.body).to include(I18n.t('posts.create.success'))
          expect(Post.last.tags).to be_empty 
        end

        it "cria o post e associa as tags corretamente" do
          post_params = { post: { title: "Novo Post", content: "Conteúdo do post" }, post_tags_attributes: [{ name: "faculdade" }] }
          post posts_path, params: post_params
          expect(response).to have_http_status(302)  
        end

    end

    context "quando os dados do post são inválidos" do
      before { login_user }

      it "não cria o post e exibe o formulário novamente" do
        post posts_path, params: invalid_post_params
        expect(response).to have_http_status(422) 
        expect(flash[:alert]).to include(I18n.t('posts.create.failure', errors:  "Title can't be blank and Content can't be blank")) 
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

  end

  describe "PATCH /posts/:id" do

    context "quando os dados do post são válidos" do
      before { login_user }
      it "atualiza o post e redireciona para a lista de posts" do
        patch post_path(post_obj), params: { post: { title: "Updated title", content: "Updated content" }, tags: 'Rails, Ruby' }
        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('posts.update.success'))
        expect(post_obj.reload.tags.map(&:name)).to include('rails', 'ruby')
      end
    end

    context "quando os dados do post são inválidos" do
        before { login_user }
      it "não atualiza o post e renderiza o formulário de edição" do
    
        patch post_path(post_obj), params: invalid_post_params
        expect(response).to have_http_status(422)
        expect(flash.now[:alert]).to include(I18n.t('posts.update.failure', errors: "Title can't be blank and Content can't be blank"))

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
        expect(response.body).to include(I18n.t('posts.destroy.success'))
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
