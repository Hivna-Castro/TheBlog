require 'rails_helper'

RSpec.describe Users::Interactors::ResetPassword, type: :interactor do
  let(:user) { create(:user, :with_reset_password_token) } 
  let(:valid_token) { user.reset_password_token }
  let(:invalid_token) { 'invalid_token' }
  let(:new_password) { 'newpassword123' }
  let(:invalid_password) { 'short' }
  
  describe '#call' do
    context 'when the token is valid' do
      context 'when the user updates the password successfully' do
        let(:params) { { token: valid_token, password: new_password, password_confirmation: new_password } }
        
        it 'resets the user password successfully' do
          interactor = described_class.call(params)

          expect(interactor).to be_success
          expect(user.reload.authenticate(new_password)).to be_truthy
          expect(interactor.message).to eq(I18n.t('users.reset_password.success'))
        end
      end

      context 'when the user fails to update the password due to validation errors' do
        let(:params) { { token: valid_token, password: invalid_password, password_confirmation: invalid_password } }
        
        it 'fails with validation errors' do
          interactor = described_class.call(params)

          expect(interactor).to be_failure
          expect(interactor.error).to match(I18n.t('users.reset_password.password_validation_error')) 
        end
      end
    end

    context 'when the token is invalid or expired' do
      let(:params) { { token: invalid_token, password: new_password, password_confirmation: new_password } }

      it 'fails with token invalid error' do
        interactor = described_class.call(params)

        expect(interactor).to be_failure
        expect(interactor.error).to eq(I18n.t('users.reset_password.failure'))
      end
    end
  end
end
