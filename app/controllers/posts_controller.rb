class PostsController < ApplicationController
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
  
    def edit
      @post = current_user.posts.find(params[:id])
    end
  
    def update
      @post = current_user.posts.find(params[:id])
      if @post.update(post_params)
        redirect_to @post, notice: "Post atualizado com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post = current_user.posts.find(params[:id])
      @post.destroy
      redirect_to root_path, notice: "Post deletado com sucesso!"
    end
  
    private
  
    def post_params
      params.require(:post).permit(:title, :content)
    end


end
