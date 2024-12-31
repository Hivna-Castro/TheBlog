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
    context "quando o usuário está autenticado" do
      before { login_user }

      it "cria um comentário com atributos válidos" do
        expect {
          post post_comments_path(post), params: { comment: comment_params }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.create.success'))
      end

      it "não cria um comentário com atributos inválidos" do
        expect {
          post post_comments_path(post), params: { comment: invalid_comment_params }
        }.not_to change(Comment, :count)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.create.failure', errors: "Content can't be blank"))
      end
    end

    context "quando o usuário não está autenticado" do
      it "cria um comentário anônimo" do
        expect {
          post post_comments_path(post), params: { comment: comment_params }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include(I18n.t('comments.create.success'))

        expect(Comment.last.anonymous).to be_truthy
      end
    end
  end

  describe "DELETE /posts/:post_id/comments/:id" do
    context "quando o usuário é o autor do comentário" do
      let!(:comment) { create(:comment, post: post, user: user) }

      before { login_user }

      it "deleta o comentário" do
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
