# Blog Application

Uma aplicação monolítica Ruby on Rails para gerenciamento de posts, comentários, e tags.

## Funcionalidades

### Área deslogada:

- Visualizar posts publicados por todos os usuários, ordenados do mais novo para o mais antigo.
- Paginação: Cada página exibe até 3 posts.
- Fazer comentários anônimos nos posts.
- Cadastrar um novo usuário.
- Fazer login com credenciais cadastradas.
- Recuperar a senha do usuário via e-mail (com API SendGrid).

### Área logada:

- Criar e publicar novos posts.
- Editar ou apagar posts do próprio usuário.
- Fazer comentários identificados (com o nome do usuário).
- Editar informações do próprio usuário.
- Alterar a senha do usuário logado.

### Funcionalidades adicionais:

- Adicionar e filtrar posts por tags (tags associadas a posts via tabela no modelo).
- Upload de arquivos TXT para criar posts ou múltiplas tags, utilizando processamento assíncrono com Sidekiq.
- Internacionalização (i18n) para suportar múltiplos idiomas.
- Testes automatizados simples (RSpec, FactoryBot, Faker, Shoulda Matchers).

---

## Tecnologias Utilizadas

- **Backend:** Ruby on Rails 7
- **Frontend:** HTML, CSS, JavaScript
- **Banco de Dados:** PostgreSQL
- **Background Jobs:** Sidekiq com Redis
- **File Uploads:** ActiveStorage
- **Envio de E-mails:** API SendGrid
- **Paginação:** Kaminari
- **Testes:** RSpec, FactoryBot, Faker, Shoulda Matchers
- **Internacionalização:** i18n
- **Deploy:** Render

---

## Deploy

https://theblog-5b6k.onrender.com

## Como Executar o Projeto Localmente

### Pré-requisitos

Certifique-se de ter os seguintes softwares instalados:

- Ruby (versão "3.3.3")
- Rails (versão `7.1.4")
- PostgreSQL
- Redis

### Passo a Passo

1. Clone o repositório:
   ```bash
   git clone <url-do-repositorio>
   cd <pasta-do-projeto>
   ```
2. Instale as dependências:
   bundle install

3. Configure o BD:
   rails db:create db:migrate db:seed

4.Configure a API SendGrid
Crie um arquivo .env na raiz do projeto e adicione a chave da API: SENDGRID_API_KEY=SEU_API_KEY
GMAIL_USERNAME=GMAIL_PARA_MADAR_EMAILS

5. Inicie o Servidor:
   rails s

6. Inicie o Sidekiq para processar jobs em segundo plano:
   bundle exec sidekiq

Desenvolvido por Hivna Castro.
E-mail: castrohivna@gmail.com
Sinta-se à vontade para entrar em contato!
