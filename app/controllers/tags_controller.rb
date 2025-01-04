class TagsController < ApplicationController
  before_action :set_tag, only: [:destroy, :destroy_from_post]
  before_action :set_post, only: [:destroy_from_post]

  def index
    @tags = Tag.all.order(:name)
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
  
    if params[:tag][:file].present?
      uploaded_file = params[:tag][:file]
      file_path = Rails.root.join("tmp", uploaded_file.original_filename)
  
      File.open(file_path, "wb") do |file|
        file.write(uploaded_file.read)
      end
  
      FileUploadTagsJob.perform_async(file_path.to_s)
  
      flash[:notice] = t('tags.created_via_file')
      redirect_to tags_path
      return
    elsif @tag.save
      flash[:notice] = t('tags.created_successfully')
      redirect_to tags_path
    else
      flash.now[:alert] = t('tags.create.failure')
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    if @tag.posts.any?
      redirect_to tags_path, alert: I18n.t('tags.destroy.associated_posts', tag_name: @tag.name)
    else
      @tag.destroy
      redirect_to tags_path, notice: I18n.t('tags.destroy.success', tag_name: @tag.name)
    end
  end

  def destroy_from_post
    if @post.tags.delete(@tag)
      redirect_to my_posts_posts_path, notice: I18n.t('tags.destroy_from_post.success', tag_name: @tag.name)
    else
      redirect_to my_posts_posts_path, alert: I18n.t('tags.destroy.failure', tag_name: @tag.name)
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def tag_params
    params.require(:tag).permit(:name, :file)
  end
end
