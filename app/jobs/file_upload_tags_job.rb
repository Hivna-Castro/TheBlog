class FileUploadTagsJob
    include Sidekiq::Job
  
    sidekiq_options queue: :tags
  
    def perform(file_path)
      return unless File.exist?(file_path)
  
      File.open(file_path, "r") do |file|
        content = file.read.strip
        tags = content.split(",").map(&:strip).uniq
  
        tags.each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
        end
      end
  
      File.delete(file_path) if File.exist?(file_path)
    end
end
  