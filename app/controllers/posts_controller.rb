class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where(tags: { name: params[:tag] }).order(created_at: :desc).page(params[:page]).per(3)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
    end
  
    @tags = Tag.order(:name) 
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :asc)
  end
  
  def new
    @post = current_user.posts.new
    @tags = Tag.order(:name)
  end
  
  def create
    @post = current_user.posts.new(post_params)
  
    if params[:post][:file].present?
      uploaded_file = params[:post][:file]
      file_path = Rails.root.join("tmp", uploaded_file.original_filename)
  
      File.open(file_path, "wb") do |file|
        file.write(uploaded_file.read)
      end
  
      FileUploadPostsJob.perform_async(file_path.to_s, current_user.id, params[:post][:tag_ids])
  
      redirect_to posts_path, notice: I18n.t('posts.create.success')
      return 
    end
  
    if @post.save
      redirect_to root_path, notice: I18n.t('posts.create.success')
    else
      @tags = Tag.all
      flash.now[:alert] = I18n.t('posts.create.failure', errors: @post.errors.full_messages.to_sentence)
      render :new, status: :unprocessable_entity
    end
  end
    
  
  def my_posts
    if params[:tag].present?
      @posts = current_user.posts.joins(:tags).where(tags: { name: params[:tag] }).order(created_at: :desc).page(params[:page]).per(3)
    else
      @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(3)
    end
  
    @tags = Tag.order(:name) 
  end

  def edit
    @tags = Tag.order(:name)
  end
  
  def update
    if @post.update(post_params)
      update_tags
      redirect_to my_posts_posts_path, notice: I18n.t('posts.update.success')
    else
      @tags = Tag.all
      flash.now[:alert] = I18n.t('posts.update.failure', errors: @post.errors.full_messages.to_sentence)
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @post.destroy
      redirect_to my_posts_posts_path, notice: I18n.t('posts.destroy.success')
    else
      redirect_to my_posts_posts_path, alert: I18n.t('posts.destroy.failure')
    end
  end
  
  private

  def update_tags
    return if params[:tags].blank?
  
    tag_names = params[:tags].split(',').map(&:strip).uniq
    tags = tag_names.map { |name| Tag.find_or_create_by(name: name.downcase) }
    @post.tags = tags
  end
  
  
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :file, tag_ids: [])
  end  

end