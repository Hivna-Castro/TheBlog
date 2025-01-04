class FileUploadJob
  include Sidekiq::Job

  sidekiq_options queue: :posts

  def perform(file_path, user_id)
    return unless File.exist?(file_path) # Garante que o arquivo existe

    File.open(file_path, "r") do |file|
      # Lê o conteúdo do arquivo e verifica o tipo
      content = file.read.strip
      lines = content.split("\n")
      title = lines.shift.strip # Usa a primeira linha como título
      content = lines.join("\n").strip # Usa o restante como conteúdo

      # Cria o post associado ao usuário
      user = User.find(user_id)
      user.posts.create!(title: title, content: content)
    end

    # Remove o arquivo após o processamento
    File.delete(file_path) if File.exist?(file_path)
  end
end