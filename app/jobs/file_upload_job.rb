class FileUploadJob
  include Sidekiq::Job

  sidekiq_options queue: :posts

  def perform(file_path, user_id)
    return unless File.exist?(file_path) 

    File.open(file_path, "r") do |file|
      content = file.read.strip
      lines = content.split("\n")
      title = lines.shift.strip 
      content = lines.join("\n").strip 

      user = User.find(user_id)
      user.posts.create!(title: title, content: content)
    end
    File.delete(file_path) if File.exist?(file_path)
  end
end