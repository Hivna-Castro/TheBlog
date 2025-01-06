require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) } 
  let(:comment) { build(:comment, post: post, user: user) }  

  describe 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user).optional } 
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }

    it 'exibe uma mensagem de erro quando o conteúdo estiver em branco' do
      comment.content = nil 
      expect(comment.valid?).to be_falsey  
      expect(comment.errors[:content]).to include(I18n.t('activerecord.errors.models.comment.attributes.content.blank'))
    end
  end
end

