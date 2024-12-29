module Users
    module Interactors
      class ResetPassword
        include Interactor
        def call
            user = User.find_by(reset_password_token: context.token)
        
            if user&.password_reset_token_valid?
              if user.update(password: context.password, password_confirmation: context.password_confirmation)
                user.clear_password_reset_token!
                context.message = "Senha redefinida com sucesso."
              else
                context.fail!(error: user.errors.full_messages.join(", "))
              end
            else
              context.fail!(error: "Token inválido ou expirado.")
            end
        end
  
      end
    end
end