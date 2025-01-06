class AllowNullForTitleAndContentInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :title, true
    change_column_null :posts, :content, true
  end
end
