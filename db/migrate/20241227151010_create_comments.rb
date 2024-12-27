class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.text :content, null: false
      t.boolean :anonymous, default: true

      t.timestamps
    end
  end
end
