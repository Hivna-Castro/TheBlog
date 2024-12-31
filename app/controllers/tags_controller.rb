class TagsController < ApplicationController
    before_action :set_post, only: [:destroy]
  
    def destroy
      tag = @post.tags.find(params[:id])
      @post.tags.delete(tag)
  
      redirect_to my_posts_posts_path, notice: "A tag '#{tag.name}' foi removida com sucesso."
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
end
  