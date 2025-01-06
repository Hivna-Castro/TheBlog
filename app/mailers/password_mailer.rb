class PasswordMailer < ApplicationMailer
    default from: '"no-reply" <castrohivna@gmail.com>'

    def reset_password_email
        @user = params[:user]
        @reset_link = reset_password_form_users_url(token: @user.reset_password_token)
        mail(to: @user.email, subject: I18n.t('password_mailer.reset_password_email.subject') ) 
    end
end
