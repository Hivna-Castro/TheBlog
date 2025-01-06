require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:post_obj) { create(:post, user: user) }
  let(:invalid_post_params) { { post: { title: "", content: "" } } }
  
  def login_user
    post login_path, params: { email: user.email, password: "password123" }
  end
  
  describe "GET /posts" do
    it "show the list of posts" do
      get posts_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Posts")
    end
  end

  describe "GET /posts/:id" do
    it "show the post" do
      get post_path(post_obj)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post_obj.title)
    end
  end

  describe "GET /posts/new" do
    context "when the user is logged in" do
      before { login_user }

      it "show the new post form" do
        get new_post_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get new_post_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /posts" do
    context "when the post data is valid" do
        before { login_user }

        it "creates the post and redirects to the post list" do
          tag_one = create(:tag)  
          tag_two = create(:tag) 

          post_params = { post: { title: "Novo Post", content: "Conteúdo do post", tag_ids: [tag_one.id, tag_two.id] } }
          post posts_path, params: post_params
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to include(I18n.t('posts.create.success'))
          expect(Post.last.tags).to include(tag_one, tag_two)
        end

        it "creates the post and correctly associates the tags" do
          post_params = { post: { title: "Novo Post", content: "Conteúdo do post" }, post_tags_attributes: [{ name: "faculdade" }] }
          post posts_path, params: post_params
          expect(response).to have_http_status(302)  
        end

    end

    context "when the post data is invalid" do
      before { login_user }

      it "does not create the post and displays the form again" do
        post posts_path, params: invalid_post_params
        expect(response).to have_http_status(422) 
        expect(flash[:alert]).to include(I18n.t('posts.create.failure'))
      end

    end
  end

  describe "GET /posts/:id/edit" do

    context "when the user is logged in" do
      before { login_user }
      it "show the post edit form" do
        get edit_post_path(post_obj)
        expect(response).to have_http_status(:ok)
      end
    end

  end

  describe "PATCH /posts/:id" do

    context "when the post data is valid" do
      before { login_user }
      it "updates the post and redirects to the post list" do
        patch post_path(post_obj), params: { post: { title: "Updated title", content: "Updated content" }, tags: 'Rails, Ruby' }
        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('posts.update.success'))
        expect(post_obj.reload.tags.map(&:name)).to include('rails', 'ruby')
      end
    end

    context "when the post data is invalid" do
      before { login_user }
      it "does not update the post and renders the edit form" do
        patch post_path(post_obj), params: invalid_post_params
        expect(response).to have_http_status(422)
        expect(response.body).to include(I18n.t('posts.update.failure'))

      end
    end
  end

  describe "DELETE /posts/:id" do

    context "when the user is logged in" do
        before { login_user }
      it "deletes the post and redirects to the post list" do
        delete post_path(post_obj)
        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(response.body).to include(I18n.t('posts.destroy.success'))
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        delete post_path(post_obj)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
