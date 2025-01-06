require 'rails_helper'

RSpec.describe Users::Interactors::GeneratePasswordResetToken, type: :interactor do
  let(:user) { create(:user) }  

  describe '#call' do
    context 'when the user exists' do
      it 'generates a reset password token and sends an email' do
    
        result = described_class.call(email: user.email)

        expect(result).to be_success
        expect(user.reload.reset_password_token).to be_present
        expect(user.reload.reset_password_sent_at).to be_present
        expect(result.message).to eq(I18n.t('users.forgot_password.success'))

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      end
    end

    context 'when the user does not exist' do
      it 'fails with an error message' do
        result = described_class.call(email: 'nonexistent@example.com')

        expect(result).to be_failure
        expect(result.error).to eq(I18n.t('users.forgot_password.failure'))
      end
    end
  end
end
