require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:tag) { create(:tag) }

  before do
    post.tags << tag
    login_user(user)  
  end
  

  describe 'GET /tags' do
    it 'lists all tags and renders the index view' do
      get tags_path  
      expect(response).to render_template(:index)
      expect(response.body).to include(tag.name)
    end
  end

  describe 'POST /tags' do
    context 'when the tag is successfully created' do
      it 'creates a new tag and redirects to the tags index with a success message' do
        expect {
          post tags_path, params: { tag: { name: 'NewTag' } }
        }.to change(Tag, :count).by(1)

        expect(response).to redirect_to(tags_path)
        follow_redirect!
        expect(flash[:notice]).to include(I18n.t('tags.create.success', tag_name: 'NewTag'))
      end
    end

    context 'when the tag creation fails' do
      it 'does not create a new tag and renders the index view with an error message' do
        expect {
          post tags_path, params: { tag: { name: '' } } 
        }.to_not change(Tag, :count)

        expect(response).to render_template(:index)
        expect(flash.now[:alert]).to include(I18n.t('tags.create.failure'))
      end
    end
  end

  describe 'DELETE /posts/:post_id/tags/:id' do
    context 'when the tag is successfully removed from the post' do
      it 'removes the tag and redirects to the my posts page with a success message' do
        expect(post.tags).to include(tag)

        delete post_tag_path(post_id: post.id, id: tag.id)
        post.reload
        expect(post.tags).not_to include(tag)

        expect(response).to redirect_to(my_posts_posts_path)
        follow_redirect!
        expect(flash[:notice]).to include(I18n.t('tags.destroy_from_post.success', tag_name: tag.name))
      end
    end
  end
end
