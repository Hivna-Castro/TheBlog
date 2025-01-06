require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }  

  describe "GET /login" do
    it "exibe o formulário de login" do
      get login_path
      expect(response).to have_http_status(:ok)  
    end
  end

  describe "POST /login" do
    context "quando as credenciais são válidas" do
      it "loga o usuário e redireciona para a página inicial" do
        post login_path, params: { email: user.email, password: "password123" }

        expect(response).to redirect_to(root_path)  
        follow_redirect!
        expect(response.body).to include(I18n.t('sessions.create.success'))  
      end
    end

    context "quando as credenciais são inválidas" do
        it "não loga o usuário e exibe mensagem de erro" do
            post '/login', params: { email: user.email, password: "wrongpassword" }
    
            expect(response.status).to eq(422) 
            expect(response.body).to include(I18n.t('sessions.create.failure'))
        end
    end
  end

  describe "DELETE /logout" do
    context "quando o usuário está logado" do
        before do
          post login_path, params: { email: user.email, password: "password123" } 
        end
    
        it "loga o usuário e redireciona para a página inicial com mensagem de sucesso" do
          get logout_path  
    
          expect(response).to redirect_to(root_path)  
          follow_redirect!
          expect(response.body).to include(I18n.t('sessions.destroy.success'))  
        end
    end
  end
end
