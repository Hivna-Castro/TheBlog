class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :asc)
  end
  
  def new
    @post = current_user.posts.new
  end
  
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def my_posts
    @posts = current_user.posts.order(created_at: :desc)
  end

  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to my_posts_posts_path, notice: "Post atualizado com sucesso!"
    else
      flash.now[:alert] = @post.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy
    redirect_to my_posts_posts_path, notice: "Post deletado com sucesso!"
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

end