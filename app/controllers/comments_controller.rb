class CommentsController < ApplicationController
    before_action :set_post
  
    def create
      @comment = @post.comments.new(comment_params)
  
      if current_user
        @comment.user = current_user
        @comment.anonymous = false 
      else
        @comment.anonymous = true  
      end
  
      if @comment.save
        redirect_to post_path(@post), notice: "Comentário criado com sucesso!"
      else
        redirect_to post_path(@post), alert: "Erro ao criar comentário: #{@comment.errors.full_messages.to_sentence}"
      end
    end
  
    def destroy
      @comment = @post.comments.find(params[:id])
  
      if @comment.user == current_user 
        @comment.destroy
        redirect_to post_path(@post), notice: "Comentário excluído com sucesso."
      else
        redirect_to post_path(@post), alert: "Você não tem permissão para excluir este comentário."
      end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
end