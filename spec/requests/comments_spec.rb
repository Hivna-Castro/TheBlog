require 'rails_helper'

RSpec.describe "Comments", type: :request do
    #refatorar todos
  let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:post) { create(:post, user: user) }
  let(:comment_params) { attributes_for(:comment, post_id: post.id, user_id: user.id) }
  let(:invalid_comment_params) { { content: "" } }

  def login_user
    post login_path, params: { email: user.email, password: "password123" }
  end

  describe "POST /posts/:post_id/comments" do
    context "when the user is authenticated" do
      before { login_user }

      it "creates a comment with valid attributes" do
        expect {
          post post_comments_path(post), params: { comment: comment_params }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.create.success'))
      end

      it "does not create a comment with invalid attributes" do
        expect {
          post post_comments_path(post), params: { comment: invalid_comment_params }
        }.not_to change(Comment, :count)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.create.failure', errors: "Content can't be blank"))
      end
    end

    context "when the user is not authenticated"do
      it "creates an anonymous comment" do
        comment_params_anonymous = attributes_for(:comment, content: "Comentário anônimo")
        
        post post_comments_path(post), params: { comment: comment_params_anonymous }
    
        expect(response).to redirect_to(post_path(post))
        follow_redirect!
    
        expect(response.body).to include(I18n.t('comments.create.success'))
        expect(post.comments.last.anonymous).to be true
        expect(post.comments.last.user).to be_nil
      end
    end
  end

  describe "DELETE /posts/:post_id/comments/:id" do
    context "when the user is the author of the comment" do
      let!(:comment) { create(:comment, post: post, user: user) }

      before { login_user }

      it "deletes the comment"  do
        expect {
          delete post_comment_path(post, comment)
        }.to change(Comment, :count).by(-1)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.destroy.success'))
      end
    end
  end
end
