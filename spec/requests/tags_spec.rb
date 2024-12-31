require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:post) { create(:post, user: user) }
  let!(:tag) { create(:tag, name: 'Faculdade') }

  before do
    post.tags << tag
  end

  def login_user
    post '/login', params: { email: user.email, password: 'password123' } 
  end

  describe 'DELETE /posts/:post_id/tags/:id' do
    before { login_user }
    
    it 'removes the tag from the post and redirects to my posts page' do
      expect(post.tags).to include(tag)
      delete post_tag_path(post_id: post.id, id: tag.id)
      post.reload
      expect(post.tags).not_to include(tag)
      expect(response).to redirect_to(my_posts_posts_path)
      follow_redirect!
      expect(flash[:alert]).to include(I18n.t('tags.destroy.success', tag_name: tag.name))
    end
  end
end


