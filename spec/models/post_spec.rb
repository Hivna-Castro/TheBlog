require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) } 

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) } 
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for tags' do
      expect(Post.nested_attributes_options).to include(:tags)
    end
  end
end
