module Users
    module Interactors
      class ResetPassword
        include Interactor
        def call
            user = User.find_by(reset_password_token: context.token)
        
            if user&.password_reset_token_valid?
              if user.update(password: context.password, password_confirmation: context.password_confirmation)
                user.clear_password_reset_token!
                context.message = I18n.t('users.reset_password.success')
              else
                context.fail!(error: user.errors.full_messages.join(", "))
              end
            else
              context.fail!(error: I18n.t('users.reset_password.failure'))
            end
        end
      end
    end
end