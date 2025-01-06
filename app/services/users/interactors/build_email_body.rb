module Users
    module Interactors
      class BuildEmailBody
        include Interactor

        def call

          user = context.user
          token = context.token
          email = context.email 
          reset_link = context.reset_link 
  
          email_body = ApplicationController.renderer.render(
            template: 'password_mailer/reset_password_email',
            locals: { user: user, reset_link: reset_link, in_email: true },
            layout: false 
          )
  
          context.body = email_body
          context.subject = I18n.t('password_mailer.reset_password_email.subject')
        end
  
      end
    end
end