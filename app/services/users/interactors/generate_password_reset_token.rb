module Users
  module Interactors
    class GeneratePasswordResetToken
      include Interactor
  
      def call
        user = User.find_by(email: context.email)

        if user
          user.reset_password_token = SecureRandom.hex(10)
          user.reset_password_sent_at = Time.current
          user.save!

          PasswordMailer.with(user: user).reset_password_email.deliver_now
          context.message = I18n.t('users.forgot_password.success')
        else
          context.fail!(error: I18n.t('users.forgot_password.failure'))
        end
      end

    end
  end
end