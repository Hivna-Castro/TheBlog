module Users
  module Interactors
    class ResetPassword
      include Interactor

      def call 
        user = User.find_by(reset_password_token: context.token)

        if user.nil?
          context.fail!(error: I18n.t('users.reset_password.invalid_token'))
          return
        end

        if user.reset_password_sent_at < 50.minutes.ago
          context.fail!(error: I18n.t('users.reset_password.token_expired'))
          return
        end

        if context.password != context.password_confirmation
          context.fail!(error: I18n.t('users.reset_password.password_mismatch'))
          return
        end

        if user.update(password: context.password, reset_password_token: nil, reset_password_sent_at: nil)
          context.success = true
          context.message = I18n.t('users.reset_password.success')
        else
          context.fail!(error: I18n.t('users.reset_password.update_failed'))
        end
      end
    end
  end
end
