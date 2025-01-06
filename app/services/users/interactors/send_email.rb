module Users
  module Interactors
    class SendEmail
      include Interactor
      require 'sendgrid-ruby'
      include SendGrid
        
      def call
        email = @context.email
        Rails.logger.debug("Sending email to: #{email}") 
        
        token = @context.token
        reset_link = @context.reset_link

        from = Email.new(email: ENV['GMAIL_USERNAME'])
        to = Email.new(email: email)
        subject = context.subject
        content = Content.new(type: 'text/plain', value: context.body)
      
        mail = Mail.new(from, subject, to, content)
      
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      
        response = sg.client.mail._('send').post(request_body: mail.to_json)
      
        puts response.status_code

        if response.status_code.to_i >= 400
          context.fail!(error: "Falha ao enviar e-mail: #{response.body}")
        else
          context.message = "E-mail enviado com sucesso para #{context.email}!"
        end
      end
    end
  end
end