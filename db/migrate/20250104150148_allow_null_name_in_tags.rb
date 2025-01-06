class AllowNullNameInTags < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tags, :name, true
  end
end
