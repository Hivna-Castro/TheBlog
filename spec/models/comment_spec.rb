require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) } 
  let(:comment) { create(:comment, post: post, user: user) } 

  describe 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user).optional } 
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end
end
