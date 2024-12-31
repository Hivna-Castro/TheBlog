require 'rails_helper'

RSpec.describe Tag, type: :model do
    let!(:tag1) { create(:tag, name: 'Faculdade') }
    let!(:tag2) { build(:tag, name: 'faculdade') }
    
    describe 'associations' do
        it { should have_and_belong_to_many(:posts) } 
    end
    
    describe 'validations' do
        it { should validate_presence_of(:name) }
        it { should validate_uniqueness_of(:name).case_insensitive }
    
        it 'validates uniqueness of name case insensitively' do
          expect(tag2).not_to be_valid
          expect(tag2.errors[:name]).to include('has already been taken')
        end
    end
end
