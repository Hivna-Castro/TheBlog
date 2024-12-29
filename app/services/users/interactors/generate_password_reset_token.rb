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
          context.message = "E-mail de redefinição enviado com sucesso."
        else
          context.fail!(error: "Usuário não encontrado.")
        end
      end

    end
  end
end