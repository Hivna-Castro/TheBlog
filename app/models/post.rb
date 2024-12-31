class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :title, presence: true
  validates :content, presence: true
end
