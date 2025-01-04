class UpdateTagsIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :tags, :name
    add_index :tags, :name, unique: true, where: "name IS NOT NULL"
  end
end
