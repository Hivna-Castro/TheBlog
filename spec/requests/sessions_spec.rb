require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }  

  describe "GET /login" do
    it "show the login form" do
      get login_path
      expect(response).to have_http_status(:ok)  
    end
  end

  describe "POST /login" do
    context "when the credentials are valid" do
      it "logs in the user and redirects to the homepage" do
        post login_path, params: { email: user.email, password: "password123" }

        expect(response).to redirect_to(root_path)  
        follow_redirect!
        expect(response.body).to include(I18n.t('sessions.create.success'))  
      end
    end

    context "when the credentials are invalid" do
        it "does not log in the user and show an error message" do
            post '/login', params: { email: user.email, password: "wrongpassword" }
    
            expect(response.status).to eq(422) 
            expect(response.body).to include(I18n.t('sessions.create.failure'))
        end
    end
  end

  describe "DELETE /logout" do
    context "when the user is logged in" do
        before do
          post login_path, params: { email: user.email, password: "password123" } 
        end
    
        it "logs out the user and redirects to the homepage with a success message" do
          get logout_path  
    
          expect(response).to redirect_to(root_path)  
          follow_redirect!
          expect(response.body).to include(I18n.t('sessions.destroy.success'))  
        end
    end
  end
end
