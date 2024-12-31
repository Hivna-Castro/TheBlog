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
        redirect_to post_path(@post), notice: I18n.t('comments.create.success')
      else
        redirect_to post_path(@post), alert: I18n.t('comments.create.failure', errors: @comment.errors.full_messages.to_sentence)
      end
    end
  
    def destroy
      @comment = @post.comments.find(params[:id])
  
      if @comment.user == current_user 
        @comment.destroy
        redirect_to post_path(@post), notice: I18n.t('comments.destroy.success')
      else
        redirect_to post_path(@post), alert: I18n.t('comments.destroy.failure')
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