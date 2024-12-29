require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }

    it { should validate_presence_of(:password).on(:update) }
    it { should validate_length_of(:password).is_at_least(8).on(:update) }
    it { should validate_confirmation_of(:password).on(:update) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    
    describe '#generate_password_reset_token!' do
      it 'generates a reset password token and sets the timestamp' do
        user.generate_password_reset_token!
        expect(user.reset_password_token).to be_present
        expect(user.reset_password_sent_at).to be_present
      end
    end

    describe '#password_reset_token_valid?' do
      it 'returns true if the token was generated less than 3 minutes ago' do
        user.update(reset_password_sent_at: 2.minutes.ago)
        expect(user.password_reset_token_valid?).to eq(true)
      end

      it 'returns false if the token was generated more than 3 minutes ago' do
        user.update(reset_password_sent_at: 5.minutes.ago)
        expect(user.password_reset_token_valid?).to eq(false)
      end
    end

    describe '#clear_password_reset_token!' do
      it 'clears the reset password token and timestamp' do
        user.update(
          reset_password_token: 'some_token',
          reset_password_sent_at: Time.current
        )
        user.clear_password_reset_token!
        expect(user.reset_password_token).to be_nil
        expect(user.reset_password_sent_at).to be_nil
      end
    end
  end
end
