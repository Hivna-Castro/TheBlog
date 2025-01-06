module Users
    module Organizers
      class SendEmailResetPassword
        include Interactor::Organizer
  
        organize(
            Users::Interactors::BuildEmailBody,
            Users::Interactors::SendEmail
          )
      end
    end
  end